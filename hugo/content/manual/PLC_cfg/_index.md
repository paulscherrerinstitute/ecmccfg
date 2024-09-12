+++  
title = "PLC cfg"   
weight = 15
chapter = false  
+++  

In `ECMC`, PLCs are a very powerful tool to handle EtherCAT data in real-time.

Since `ecmccfg` v7, the PLCs can be instantiated from:
- [pure yaml](#pure-yaml) files or
- text files, with [yaml header](#yaml-header).

{{% notice info %}}
Backwards compatibility for classic, text based PLCs is assured.
{{% /notice %}}

{{% notice warning %}}
`yaml` is - like `python` - indentation sensitive!
{{% /notice %}}

{{% notice tip %}}
Indent with 2 spaces.
{{% /notice %}}

## pure yaml

All keys are mandatory.

- `id`: PLC id, unique **uint**
- `enable`: PLC enabled at start
- `rateMilliseconds`: execution rate in ms. To execute every cycle, independant of cycle rate, use `-1`.
- `code`: dictionary of code lines.

{{% notice note %}}
Line terminator is still a pipe `|`, this is subject to change!
{{% /notice %}}

{{% notice tip %}}
For more complex PLCs, it is highly advisable to use text based PLC definitions with a [yaml header](#yaml-header).
{{% /notice %}}

```yaml
plc:
  id: 1
  enable: no
  rateMilliseconds: 10
  code:
    - 'ec0.s2.binaryOutput07:=global.test|'
    - '${PLC_ID}.enable:=plc0.enable|'
    - 'ec0.s2.binaryOutput05:=not(ec0.s2.binaryOutput05)|'
    - 'plc1.error:=12345|'
```

## yaml header
Instead of the code dictionary, the `file` key can be used to load the PLC from a text file.
The syntax of the text PLCs is kept from earlier versions.

All keys are mandatory.

- `id`: PLC id, unique **uint**
- `enable`: PLC enabled at start
- `rateMilliseconds`: execution rate in ms. To execute every cycle, independant of cycle rate, use `-1`.
- `file`: PLC text file to load.

{{% notice warning %}}
If the `file` key is set, all definitions in the `code` dictionary are overwritten.
{{% /notice %}}

> yaml header
```yaml
plc:
  id: 1
  enable: yes
  rateMilliseconds: 10
  file: plc1.plc
```

> PLC file
```shell
# this is a comment
println('plc1 from file');
println('plc1 from file # hash with inline comment'); # inline test
static.i:=static.i+1; # counter
println('i = # + - * / ', static.i); # println
```

> `iocsh` call
```shell
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}loadYamlPlc.cmd" "FILE=./plc1File.yaml, ECMC_TMPDIR=/tmp/"
```
