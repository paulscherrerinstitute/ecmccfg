# EoE support

## Etherlab master

Etherlab needs the "unofficial" patchset in order for the EoE to work proper:
* See icshwi/etherlabmaster/README.md for instructions:
  * make clean
  * remove /opt/etherlab (if it exists)
  * Set WITH_PATHSET=YES
  * make patchset (instead of make init)
  * then same workflow as normal (without patchset)
  * ecmc needs to be recompiled and installed (make sure that the /opt/etherlab/ is the patched version)   




