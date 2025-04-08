#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dbDefs.h>
#include <aSubRecord.h>
#include <epicsExport.h>
#include <epicsThread.h>
#include <epicsMutex.h>
#include <epicsEvent.h>
#include <dbAccess.h>
#include <dbAddr.h>
#include <registryFunction.h>

static epicsMutexId scriptLock;
static epicsEventId scriptEvent;
static char scriptPath[512];
static char globalStausPvName[64];
static volatile int hasJob = 0;

void updateStatEtherCATTool(const char *statusStr) {	
	char status[16];
    strncpy(status, statusStr, sizeof(status) - 1);
    status[sizeof(status) - 1] = '\0';    
}
 
// === Worker thread ===
void workerEtherCATTool(void *arg) {

    while (1) {
		printf("workerEtherCATTool(): Executing: \"%s\"\n",scriptPath);

        epicsEventWait(scriptEvent);
        epicsMutexLock(scriptLock);
        if (hasJob) {			
            updateStatEtherCATTool("BUSY");
            int ret = system(scriptPath);
			//printf("Returned with %d\n",ret);
            updateStatEtherCATTool(ret == 0 ? "IDLE" : "ERROR");
            hasJob = 0;
        }
        epicsMutexUnlock(scriptLock);
    }
}
 
// === Init at IOC boot ===
static void initEtherCATTool(struct aSubRecord *rec) {
	memset(globalStausPvName,0, sizeof(globalStausPvName));
    scriptLock = epicsMutexCreate();
    scriptEvent = epicsEventCreate(epicsEventEmpty);
    epicsThreadCreate("EtherCAT worker",
                      epicsThreadPriorityLow,
                      epicsThreadGetStackSize(epicsThreadStackMedium),
                      workerEtherCATTool,
                      NULL);
	printf("initEtherCATTool\n");
}
epicsRegisterFunction(initEtherCATTool);

// Cmd 70621: Execute tuning
static int el7062ExeAutoTune(int master, int slave, int channel, char* epics, char *ecmccfg, char * prefix) {
  size_t charCount = snprintf(scriptPath,
  	      sizeof(scriptPath),
  	      "bash /ioc/modules/ecmccfg/%s/R%s/el7062_triggTune.sh %d %d %d %s\n",
	      ecmccfg,
	      epics,
  	      master,
  	      slave,
          channel,
		  prefix);
  if (charCount >= sizeof(scriptPath) - 1) {
  	return -1;
  }
  hasJob=1;
  return 0;
}

// Cmd 70622: Readback params
static int el7062ReadBackParams(int master, int slave, int channel, char* epics, char *ecmccfg, char * prefix) {
	size_t charCount = snprintf(scriptPath,
			  sizeof(scriptPath),
			  "bash /ioc/modules/ecmccfg/%s/R%s/el7062_readBackParams.sh %d %d %d %s\n",
			  ecmccfg,
			  epics,
			  master,
			  slave,
			  channel,
			  prefix);
	if (charCount >= sizeof(scriptPath) - 1) {
		return -1;
	}
	hasJob=1;
	return 0;
  }
  
/* command:                             arg1
  1: trigger auto tune: master, slave,  chId
*/

// Asub-interface:
//  A: Master ID   (double)
//  B: Command ( tune 70621, 70622)
//  C: Spare
//  D: Slave ID    (double)
//  E: Channel ID  (double)
//  F: sdoIndex    (double)
//  G: sdoSubIndex (double)
//  H: data type   (string)
//  I: command specific arg   (double)
//  R: Prefix
//  S: epics version (string)
//  T: ecmccfg version (string)
//  U: Trigger
//  VALA: Status
// ${P}${ECMC_EC_MP}${MASTER_ID}-EcTool

static long runEtherCATTool(struct aSubRecord *rec) {
	// a triggers script	
    double *masterId    = (double *)rec->a;
	double *cmd         = (double *)rec->b;	

	double *slaveId     = (double *)rec->d;
	double *chId        = (double *)rec->e;
	
	double *triggerCmd  = (double *)rec->u;
	char   *prefix      = (char *)rec->r;
	char   *epics_ver   = (char *)rec->s;
    char   *ecmccfg_ver = (char *)rec->t;
    
	if(!*triggerCmd) {
		return 0;
	}

	epicsMutexLock(scriptLock);
    if (hasJob) {
        printf("Busy, ignoring trigger.\n");
        epicsMutexUnlock(scriptLock);
        return -1;
	}

	switch((int)*cmd) {
      case 70621: // autotune EL7062
	    el7062ExeAutoTune((int)*masterId, (int)*slaveId, (int)*chId, epics_ver, ecmccfg_ver, prefix);
		break;
	  case 70622: // readback parameters
        el7062ReadBackParams((int)*masterId, (int)*slaveId, (int)*chId, epics_ver, ecmccfg_ver, prefix);		
	    break;
	}

    epicsEventSignal(scriptEvent);
    epicsMutexUnlock(scriptLock);
    return 0;
}
epicsRegisterFunction(runEtherCATTool);
