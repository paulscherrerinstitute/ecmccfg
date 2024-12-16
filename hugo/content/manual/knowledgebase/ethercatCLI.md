+++  
title = "ethercat command line interface"   
weight = 13
chapter = false  
+++

### `ethercat` CLI

The IgH EtherCAT master provides a command line interface (CLI) which is a very powerful tool.
The most common commands will be explained here.

#### `ethercat master`
This will show the state of _all_ masters on the respective host.

{{% notice tip %}}
The command will show the state of _all_ masters. To limit the command to a single master, make use of the `-m` parameter.
{{% /notice %}}

{{% notice tip %}}
The `-m` parameter is available to all `ethercat` commands, and is even require by some in case of multiple masters. Check the help by issuing `ethercat -h` for details.
{{% /notice %}}

Example:
```bash
ethercat master
```
```bash
Master0
  Phase: Operation
  Active: yes
  Slaves: 38
  Ethernet devices:
    Main: b4:7a:f1:30:7e:d5 (attached)
      Link: UP
      Tx frames:   133210322
      Tx bytes:    11957093893
      Rx frames:   133210320
      Rx bytes:    11957093737
      Tx errors:   0
      Tx frame rate [1/s]:    500    500    500
      Tx rate [KByte/s]:     43.4   43.4   43.3
      Rx frame rate [1/s]:    500    500    500
      Rx rate [KByte/s]:     43.4   43.4   43.3
    Common:
      Tx frames:   737445202
      Tx bytes:    114898987125
      Rx frames:   737445184
      Rx bytes:    114898984314
      Lost frames: 18
      Tx frame rate [1/s]:    500    500    500
      Tx rate [KByte/s]:     43.4   43.4   43.3
      Rx frame rate [1/s]:    500    500    500
      Rx rate [KByte/s]:     43.4   43.4   43.3
      Loss rate [1/s]:          0      0      0
      Frame loss [%]:         0.0    0.0    0.0
  Distributed clocks:
    Reference clock:   Slave 0
    DC reference time: 708164169043902491
    Application time:  708427716430011969
                       2022-06-13 09:28:36.430011969
```

In case the numbers mostly zero, check the link state.
```bash
Ethernet devices:
    Main: b4:7a:f1:30:7e:d5 (attached)
      Link: UP <--- HERE
```
If the link is `DOWN`, try bringing the network device up manually.
This, can be done with `ip link set <nameOfNetworkDevice> up`

If the device name is unknown, check with `ip link show` and search for the MAC the EtherCAT master is bound to.

### `ethercat slaves`
As the command suggest, this will provide a list of the EtherCAT slaves.

Example:
```bash
ethercat slaves
```

```bash
 0  0:0   PREOP  +  EK1100 EtherCAT Coupler (2A E-Bus)
 1  0:1   PREOP  +  EL9227-5500 ?berstromschutz 24V DC, 2K., max. 10A (Summe), eins
 2  0:2   PREOP  +  EL1034 4K. Dig. Eingang 24V, potenzialfrei, 10?s
 3  0:3   PREOP  +  EL5042 2Ch. BiSS-C Encoder
 4  0:4   PREOP  +  EL5042 2Ch. BiSS-C Encoder
 5  0:5   PREOP  +  EL9410 E-Bus Netzteilklemme (Diagnose)
 6  0:6   PREOP  +  EL9576 Bremschopper Klemme
 7  0:7   PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
 8  0:8   PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
 9  0:9   PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
10  0:10  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
11  0:11  PREOP  +  EK1100 EtherCAT-Koppler (2A E-Bus)
12  0:12  PREOP  +  EL9227-5500 ?berstromschutz 24V DC, 2K., max. 10A (Summe), eins
13  0:13  PREOP  +  EL1034 4K. Dig. Eingang 24V, potenzialfrei, 10?s
14  0:14  PREOP  +  EL1034 4K. Dig. Eingang 24V, potenzialfrei, 10?s
15  0:15  PREOP  +  EL1034 4K. Dig. Eingang 24V, potenzialfrei, 10?s
16  0:16  PREOP  +  EL5042 2Ch. BiSS-C Encoder
17  0:17  PREOP  +  EL5042 2Ch. BiSS-C Encoder
18  0:18  PREOP  +  EL5042 2Ch. BiSS-C Encoder
19  0:19  PREOP  +  EL3314 4K. Ana. Eingang Thermoelement (TC)
20  0:20  PREOP  +  EL9410 E-Bus Netzteilklemme (Diagnose)
21  0:21  PREOP  +  EL9576 Bremschopper Klemme
22  0:22  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
23  0:23  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
24  0:24  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
25  0:25  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
26  0:26  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
27  0:27  PREOP  +  EL7041 1Ch. Stepper motor output stage (50V, 5A)
28  0:28  PREOP  +  EKM1101 EtherCAT Coupler  (2A E-Bus, ID switch, Diagnostics, is
29  0:29  PREOP  +  ELM3004-0000 4K. Ana. Eingang +/-30V, 24 bit, hochgenau
30  0:30  PREOP  +  ELM3146-0000 6Ch. Ana. Input +/-10V, +/-20mA, 24 bit, high prec
31  0:31  PREOP  +  ELM3602-0002 2Ch. IEPE Sensor, 24 bit, high precision
32  0:32  OP     +  EP7047-1032 1K. Schrittmotor-Endstufe (50V, 5A)
33  0:33  OP     +  EP5001-0002 1K. SSI Encoder
34  0:34  PREOP  +  EP7041-0002 1K. Schrittmotor-Endstufe (50V, 5A)
35  0:35  PREOP  +  EP7211-0034 1Ch. MDP742 Servo motor output stage with OCT (50V,
36  0:36  PREOP  +  EP7211-0034 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
37  0:37  PREOP  +  EP7211-0034 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
```

### `ethercat sdos`
Download and display the **service data objects**.

{{% notice warning %}}
Use with caution as this command can take a long time to fetch all data. It is advised to limit the download to the specific slave in question, with the `-p <slaveID>` parameter.
{{% /notice %}}

### `ethercat pdos`
Similar to the `sdos` counterpart, this command will fetch the currently applied **process data objects**.
To avoid excessive output, it is advised to limit the command to a single slave.

### `ethercat upload`
With this command the value of a register can be fetched.

{{% notice info %}}
If the `type` is not explicitly given, first issue `ethercat -p <slaveID> sdos`. This will allow implicit type handling.
{{% /notice %}}

Example:
Fetch content of register `0x8020`, sub-register `0x05` from slave `32`.
```bash
ethercat upload  -m0 -p32 0x8020 0x05
```

```bash
0x03e8 1000
```

### `ethercat download`
With this command the value of a register can be set on the slave.

{{% notice info %}}
If the `type` is not explicitly given, first issue `ethercat -p <slaveID> sdos`. This will allow implicit type handling.
{{% /notice %}}

Example:
Set value of register `0x8010`, sub-register `0x07` from slave `7` to `314`.
```bash
ethercat download  -m0 -p7 0x8010 0x07 314
```

### `ethercat states`
With this command a specific state of a slave can be forced, or at least an attempt to enter the specific state is made.

This is helpful when a slave is stuck, e.g. with an error. Rather than cycle the power of the entire controller, the slave can be set to 'REBOOT'. This might be enough to recover.

Alternatively, cycling to 'INIT' and back to 'OP' might also be attempted.

{{% notice info %}}
A power cycling of the of the EtherCAT components is the **last** resort! 
{{% /notice %}}
