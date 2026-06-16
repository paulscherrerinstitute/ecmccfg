+++
title = "ELxxxx"
weight = 16
chapter = false
+++

## Scope
Use this page for general Beckhoff terminal power-bus questions, especially
mixed 5V and 24V terminal chains.

## Power bus - 5V or 24V terminals
24V is the most common signal level for the terminals. However, some also support other voltage levels, for instance 5V or 12V.
In that case, normally the terminal needs to be powered with the same voltage.
For 5V terminals, normally an EL9505 is added before the 5V terminal in the EtherCAT chain, supplying the power bus with 5V.

Example of slaves needing 5V power supply:
* EL1124
* EL1252-0050
* ...

{{% notice warning %}}
**If a 5V terminal is supplied with 24V it will most likely break. Make sure the terminals have the correct power supply __before__ powering the system.**
{{% /notice %}}

{{% notice note %}}
**The voltage level of the power bus after (downstream of) a 5V terminal is normally also 5V. If another voltage is needed, then another system terminal is needed to set a new voltage level of the power bus.**
{{% /notice %}}

## Analog input/output display macros
Most scalar analog input and analog output substitutions in `db/Beckhoff_3XXX`
and `db/Beckhoff_4XXX` support override macros for common EPICS display and
conversion fields.

These macros are named with a leading underscore because the substitution file
uses them as defaults for the normal record fields:

| Macro | Record field | Typical use |
| --- | --- | --- |
| `_ESLO` | `ESLO` | Scaling factor |
| `_EOFF` | `EOFF` | Scaling offset |
| `_EGU` | `EGU` | Engineering unit |
| `_PREC` | `PREC` | Display precision |

Example:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=12, HW_DESC=EL3174_0to10V, MACROS='_EGU=mm,_PREC=4'"
```

The same override value is applied to all scalar channels in that substitution
file. If the substitution file contains different channel defaults and only one
channel should change, create or use a more specific substitution file instead.

{{% notice note %}}
These `_XXXX` macros are intended for scalar analog records. They are not used
for waveform/array substitutions such as oversampling terminals.
{{% /notice %}}

## Related Pages
- [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})
- [EL1xxx]({{< relref "/manual/knowledgebase/hardware/EL1xxx.md" >}})
- [EL9xxx]({{< relref "/manual/knowledgebase/hardware/EL9xxx.md" >}})
