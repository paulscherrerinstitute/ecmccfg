# Filtering of encoder act position

In this directory three examples of how to filter actual encoder values are presented:

1. Preferred way: Use the built in filters in encoder object. See enc_filt.script:
```
####################################################################
## NOTE!!! Additional encoder filter variables
epicsEnvSet("ECMC_ENC_VEL_FILTER_SIZE",  "100")
epicsEnvSet("ECMC_ENC_POS_FILTER_SIZE",   "10")
epicsEnvSet("ECMC_ENC_POS_FILTER_ENABLE", "1")
####################################################################
```

2. Use of data storage and simulated ec entry. See enc_filt_ds.script

3. Use of virt axis and data storage. See enc_filt_virt_ds.script

The last two alternatives of filtering is not preffered and only kept for refernce of tests done. Both these have certain issues (therefore a builtin filter was implemented in the encoder object):

2. Over/underflow of encoder data is not handled. As a workaround try to avoid over/underflow. For instance if possible then choose 32bit encoder value instead of 16bits..

3. Homing will not work.
