// aSub, EPICS related headers
#include <aSubRecord.h>
#include <registryFunction.h>
#include <epicsExport.h>
// std::cout
#include <iostream>
// split double into fractional and integer
#include <math.h>

// declare init function
static long ECATtimestampInit(struct aSubRecord *rec);
epicsRegisterFunction(ECATtimestampInit);

// declare worker function
static long ECATtimestamp(struct aSubRecord *rec);
epicsRegisterFunction(ECATtimestamp);

// init (INAM)
static long ECATtimestampInit(struct aSubRecord *rec){
  std::cout << "ECATtimestamp aSubRecord: "<< rec->name << std::endl;
  return 0;
}

// work (SNAM)
static long ECATtimestamp(struct aSubRecord *rec){

	/*
			timestamp from EtherCAT has epoch 2000-01-01 00:00 UTC
	 		UNIX epoch offset --> 946684800 s
			value in nanoseconds
	*/
	double ECMC_timestamp	= *((double *)rec->a);
	ECMC_timestamp /= 1000000000;                           // scale to seconds
  ECMC_timestamp += 946684800-POSIX_TIME_AT_EPICS_EPOCH;  // apply offset
	// split integer and fractional seconds
	double integer, fractional;
	fractional = modf(ECMC_timestamp, &integer);

	// EPICS timestamp struct
	epicsTimeStamp t;
	t.secPastEpoch=(unsigned long)integer;
	t.nsec=(unsigned long)(fractional*1000000000);
	// set record timestamp, needs TSE=-2
	rec->time = t;
  // return nanosecond part of timestamp
  return t.nsec;
}

/*
--------------------------------------------------------------------------------
EPICS database example
record(aSub,  "${SYS}:ECATtimestamp") {
  field(DESC,  "ECAT timestamp")
  field(INAM,  "ECATtimestampInit")
  field(SNAM,  "ECATtimestamp")
  field(FTA,   "DOUBLE")
  field(NOA,   1)
  field(TSE,  -2)
}
--------------------------------------------------------------------------------
*/
