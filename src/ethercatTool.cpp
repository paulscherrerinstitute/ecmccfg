//
// ECMCCFG ethercatTool
//
// provides host-related commands that can be configured and executed via a
// EPICS record:
//
// ${P}${ECMC_EC_MP}${MASTER_ID}-EcTool
//
// | field | description      | datatype |
// |-------|------------------|----------|
// | A     | master id        | double   |
// | B     | command          | double   |
// | C     | reserved         |          |
// | D     | slave id         | double   |
// | E     | channel id       | double   |
// | F     | sdo index        | double   |
// | G     | sdo subindex     | double   |
// | H     | data type        | string   |
// | I     | command argument | double   |
// | R     | prefix           | string   |
// | S     | epics version    | string   |
// | T     | ecmccfg version  | string   |
// | U     | trigger          | double   |
// | VALA  | return status    | double   |
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <aSubRecord.h>
#include <dbAccess.h>
#include <dbAddr.h>
#include <dbDefs.h>
#include <epicsEvent.h>
#include <epicsExport.h>
#include <epicsMutex.h>
#include <epicsThread.h>
#include <registryFunction.h>

#define EC_SLAVES_MAX 65535

enum EcToolCommand {
  CMD_CHANGE_EC_STATE = 10,
  CMD_EL7062_AUTOTUNE = 70621,
  CMD_EL7062_READBACK = 70622
};

void updateStatEtherCATTool(const char *);
void workerEtherCATTool(void *);
static void initEtherCATTool(struct aSubRecord *);
static long runEtherCATTool(struct aSubRecord *);

static int setupChangeSlaveEtherCATstate(int, int, int);
static int setupEL7062ExeAutoTune(int, int, int, char *, char *, char *);
static int setupEL7062ReadBack(int, int, int, char *, char *, char *);

// globals
static epicsEventId scriptEvent;
static epicsMutexId scriptLock;
static char scriptPath[512];
static char globalStausPvName[64];
static volatile int hasJob = 0;


void updateStatEtherCATTool (const char *statusStr) {
    char status[16];
    strncpy(status, statusStr, sizeof(status) - 1);
    status[sizeof(status) - 1] = '\0';
}


void workerEtherCATTool(void *arg)
{
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


static void initEtherCATTool (struct aSubRecord *rec)
{
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


static long runEtherCATTool (struct aSubRecord *rec)
{
    double *a = (double *)rec->a;           // A: master id (double)
    int masterId = (int)*a;

    double *b = (double *)rec->b;           // B: command (double)
    int cmd = (int)*b;

    // unused                               // C: spare

    double *d = (double *)rec->d;           // D: slave id (double)
    int slaveId = (int)*d;

    double *e = (double *)rec->e;           // E: channel id (double)
    int chId = (int)*e;

    // unused                               // F: sdoIndex    (double)
    // unused                               // G: sdoSubIndex (double)
    // unused                               // H: data type   (string)

    double *i = (double *)rec->i;           // I: command specific arg (double)
    int cmdArg = (int)*i;

    char *prefix = (char *)rec->r;          // R: prefix  (string)
    char *epicsVer = (char *)rec->s;        // S: epics version (string)
    char *ecmccfgVer = (char *)rec->t;      // T: ecmccfg_ver (string)
    double *triggerCmd = (double *)rec->u;  // U: trigger (double)


    // sanity checks
    if (!*triggerCmd)
        return 0;

    if (masterId < 0)
        return -1;

    if ((slaveId < 0) || (slaveId > EC_SLAVES_MAX))
        return -1;

    epicsMutexLock(scriptLock);
    if (hasJob) {
        printf("Busy, ignoring trigger.\n");
        epicsMutexUnlock(scriptLock);
        return -1;
    }

    switch(cmd) {
        case CMD_CHANGE_EC_STATE:
            setupChangeSlaveEtherCATstate(masterId, slaveId, cmdArg);
            break;
        case CMD_EL7062_AUTOTUNE:
            setupEL7062ExeAutoTune(masterId, slaveId, chId, epicsVer, ecmccfgVer, prefix);
            break;
        case CMD_EL7062_READBACK:
            setupEL7062ReadBack(masterId, slaveId, chId, epicsVer, ecmccfgVer, prefix);
            break;
    }

    epicsEventSignal(scriptEvent);
    epicsMutexUnlock(scriptLock);
    return 0;
}
epicsRegisterFunction(runEtherCATTool);


static int setupChangeSlaveEtherCATstate(int masterId, int slaveId, int cmdArg) {

  char stateName[sizeof("SAFEOP")] = "";
  bool isValidState = true;

  switch(cmdArg) {
    case 1:  strcpy(stateName, "INIT")   ; break;
    case 2:  strcpy(stateName, "PREOP")  ; break;
    case 3:  strcpy(stateName, "BOOT")   ; break;
    case 4:  strcpy(stateName, "SAFEOP") ; break;
    case 8:  strcpy(stateName, "OP")     ; break;
    default: isValidState = false        ; break;
  }

  if (false == isValidState)
    return -1;

  size_t charCount = snprintf(scriptPath,
      sizeof(scriptPath),
      "/opt/etherlab/bin/ethercat states -m%d -p%d %s\n",
      masterId,
      slaveId,
      stateName);

  if (charCount >= sizeof(scriptPath) - 1)
    return -1;

  hasJob=1;
  return 0;
}


static int setupEL7062ExeAutoTune(int master, int slave, int channel, char* epics, char *ecmccfg, char * prefix)
{
    size_t charCount = snprintf(scriptPath,
            sizeof(scriptPath),
            "bash /ioc/modules/ecmccfg/%s/R%s/el7062_triggTune.sh %d %d %d %s\n",
            ecmccfg,
            epics,
            master,
            slave,
            channel,
            prefix);

    if (charCount >= sizeof(scriptPath) - 1)
        return -1;

    hasJob=1;
    return 0;
}


static int setupEL7062ReadBack(int master, int slave, int channel, char* epics, char *ecmccfg, char * prefix)
{
    size_t charCount = snprintf(scriptPath,
            sizeof(scriptPath),
            "bash /ioc/modules/ecmccfg/%s/R%s/el7062_readBackParams.sh %d %d %d %s\n",
            ecmccfg,
            epics,
            master,
            slave,
            channel,
            prefix);

    if (charCount >= sizeof(scriptPath) - 1)
        return -1;

    hasJob=1;
    return 0;
}
// vim: ts=4 sw=4 et
