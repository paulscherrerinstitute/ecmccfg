# `MTEST04-MTN-CPP-LOGIC`

This IOC example uses the native control and utility helpers on the same direct
EL7041 mapping as the minimal example.

The source tree is:

- `src/main.cpp`
- `src/Makefile`
- `MTEST04-MTN-CPP-LOGIC_startup.script`
- `MTEST04-MTN-CPP-LOGIC_parameters.yaml`

Expected flow:

1. `make`
2. Optional `make pvs`
3. Optional  `make ui`
4. `make install`
5. start the IOC with `MTEST04-MTN-CPP-LOGIC_startup.script`

The build stages:

- `bin/main.so`
- `cfg/libmain.so_cpp_logic.subs`
- `qt/MTEST04-MTN-CPP-LOGIC_cpp_logic.ui`

The startup script loads the built-in core PVs by default. To load the
generated `epics.*` PVs too, pass the substitutions file explicitly:

- `EPICS_SUBST=cfg/libmain.so_cpp_logic.subs`

`make ui` generates a simple IOC-local caQtDM panel:

```sh
caqtdm qt/MTEST04-MTN-CPP-LOGIC_cpp_logic.ui
```
