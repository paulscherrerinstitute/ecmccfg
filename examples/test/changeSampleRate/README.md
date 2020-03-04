# Sample rate change

The default sample rate of ecmc is 1kHz. The sample rate can be changed during configuration phase (needs to be before any object creation).

Lowering a sample rate could be benefical:
* Lowering cpu/resource usage
* Less sensitivity to jitter
* ...

Sometimes also higher sample can be benefical:
* Accuire more data
* Increase control performance
* ..

Note 1: Some of the hardware supported by ecmc, mainly dc-enabled and oversampling slaves where the command "Cfg.EcSlaveConfigDC()" are used, are configured for a sample rate of 1kHz (dc syncs and offsets).
If these slaves are to be used at a different rate new configuration file(s) might need to be created (with updated "Cfg.EcSlaveConfigDC()" settings).

Note 2: Not all slaves support sample rates higher than 1kHz. Check docs.

Note 3: For lower sample rates it takes longer time for the EtherCAT bus to startup. 
The EtherCAT startup timeout might need to be increased ("ecmcConfigOrDie "Cfg.SetEcStartupTimeout(<timeInSeconds>)", default 30s)

Note 4: Lower samplerates than 50Hz have been identified as unstable when using more complex slaves:
* DC enabled slaves like drives
* oversampling slaves 
* position measurement slaves.
This is most likely for the dc clock synronization will fail when to long between sync telegrams.
Low sample rate for pure digital or analog have shown to be stable.

This rate can be changed by:

1. Preferred way. Write to the parameter "EC_RATE" of startup.cmd (unit of EC_RATE is [Hz]):

```
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=<ecmcVersion>,stream_VER=<stremVer>, EC_RATE=<rate>"
```

2. Issueing the command "ecmcConfigOrDie "Cfg.SetSampleRate(<sampleRate>)" where the unit of sampleRate is [Hz]:

```
ecmcConfigOrDie "Cfg.SetSampleRate(500)"
```
3. Issueing the command "ecmcConfigOrDie "Cfg.SetSampleTimeMs(<sampleTimeMs>)" where unit of sampleTime is [ms]:
```
ecmcConfigOrDie "Cfg.SetSampleTimeMs(2)"
```

Note: The commands "Cfg.SetSampleRate()" or "Cfg.SetSampleTimeMs()" needs to be executed before any ecmc configuration 
is performed but of cource after the "require ecmc" statement. Therefore the parameter EC_RATE is the prefereed way to handle changed sample rates.

