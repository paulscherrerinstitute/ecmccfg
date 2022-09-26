
# Notes on PVs


## Motor Record Field vs ecmc PVs

Item | Motor record field | ecmc PV           | Comment |
---  | ---                | ---               | ---     | 
1    | <axis>.RBV         | <axis>-PosAct     | Actual position| 
2    | <axis>.VAL         | <axis>-PosSet     | Position Setpoint. ecmc <axis>-PosSet is the trajectory generated setpoint while the .VAL is only the target position |
3    | <axis>.VAL         | <axis>-TgtPosCmd  | Target position. However, the ecmc pv will only be updated if running without motor record |
4    | <axis>.LLS         | <axis>-LimBwd     | Low limit switch. Note: Inverted |
5    | <axis>.HLS         | <axis>-LimFwd     | High limit switch. Note: Inverted |
6    | <axis>.CNEN        | <axis>-EnaAct     | Power enabled |
7    | <axis>.DMOV        | <axis>-Busy       | Done move, axis busy. Same but inverted |
7    | <axis>.MOVN        | <axis>-Moving     | Axis moving |

## All axis related PVs
```
IOC_TEST:Axis1-DbgStrToLOG
IOC_TEST:Axis1-EnaCmd
IOC_TEST:Axis1-ExeCmd
IOC_TEST:Axis1-StpCmd
IOC_TEST:Axis1-RstCmd
IOC_TEST:Axis1-EncSrcTyp-Cmd
IOC_TEST:Axis1-TrjSrcTyp-Cmd
IOC_TEST:Axis1-PLC-EnaCmd
IOC_TEST:Axis1-CmdFrmPLCCmd
IOC_TEST:Axis1-SftLimBwdEna
IOC_TEST:Axis1-SftLimFwdEna
IOC_TEST:Axis1-HomProc-RB
IOC_TEST:Axis1-Type
IOC_TEST:Axis1-DrvType
IOC_TEST:Axis1-TrajType
IOC_TEST:Axis1-MtnCmd
IOC_TEST:Axis1-OFF_
IOC_TEST:Axis1-MRES_
IOC_TEST:Axis1-HomPos
IOC_TEST:Axis1-VelToHom
IOC_TEST:Axis1-VelFrmHom
IOC_TEST:Axis1-AccHom
IOC_TEST:Axis1-TgtPosCmd
IOC_TEST:Axis1-TgtVelCmd
IOC_TEST:Axis1-Stat_
IOC_TEST:Axis1-Arr-Stat
IOC_TEST:Axis1-PLC-Expr-RB
IOC_TEST:Axis1-MR-ErrId
IOC_TEST:Axis1-CfgRDBD-En-RB
IOC_TEST:Axis1-CfgPOSLAG-En-RB
IOC_TEST:Axis1-CfgDHLM-En-RB
IOC_TEST:Axis1-CfgDLLM-En-RB
IOC_TEST:Axis1-Stat
IOC_TEST:Axis1-ErrId
IOC_TEST:Axis1-EnaCmd-RB
IOC_TEST:Axis1-EnaAct
IOC_TEST:Axis1-ExeCmd-RB
IOC_TEST:Axis1-Busy
IOC_TEST:Axis1-AtTarget
IOC_TEST:Axis1-Moving
IOC_TEST:Axis1-LimFwd
IOC_TEST:Axis1-LimBwd
IOC_TEST:Axis1-HomeSwitch
IOC_TEST:Axis1-Homed
IOC_TEST:Axis1-InRT
IOC_TEST:Axis1-TrjSrcTyp-RB
IOC_TEST:Axis1-EncSrcTyp-RB
IOC_TEST:Axis1-CmdFrmPLCCmd-RB
IOC_TEST:Axis1-SftLimFwdEna-RB
IOC_TEST:Axis1-SftLimBwdEna-RB
IOC_TEST:Axis1-PLC-EnaCmd-RB
IOC_TEST:Axis1-PLC-FirstScan
IOC_TEST:Axis1-SeqState
IOC_TEST:Axis1-LastIlock
IOC_TEST:Axis1-Cmd_
IOC_TEST:Axis1-DIR_
IOC_TEST:Axis1-ErrRst
IOC_TEST:Axis1-HomProc
IOC_TEST:Axis1-MtnCmdData
IOC_TEST:Axis1-MsgTxt
IOC_TEST:Axis1-Vel-RB
IOC_TEST:Axis1-Acc-RB
IOC_TEST:Axis1-EncAct
IOC_TEST:Axis1-CfgSREV-RB
IOC_TEST:Axis1-CfgUREV-RB
IOC_TEST:Axis1-CfgPMIN-RB
IOC_TEST:Axis1-CfgPMAX-RB
IOC_TEST:Axis1-CfgSPDB-RB
IOC_TEST:Axis1-CfgRDBD-RB
IOC_TEST:Axis1-CfgRDBD-Tim-RB
IOC_TEST:Axis1-CfgPOSLAG-RB
IOC_TEST:Axis1-CfgPOSLAG-Tim-RB
IOC_TEST:Axis1-CfgDHLM-RB
IOC_TEST:Axis1-CfgDLLM-RB
IOC_TEST:Axis1-CfgVELO-RB
IOC_TEST:Axis1-CfgVMAX-RB
IOC_TEST:Axis1-CfgJVEL-RB
IOC_TEST:Axis1-CfgACCS-RB
IOC_TEST:Axis1-HomPos-RB
IOC_TEST:Axis1-PosAct
IOC_TEST:Axis1-VelAct
IOC_TEST:Axis1-PosSet
IOC_TEST:Axis1-PosErr
IOC_TEST:Axis1-PLC-Err
IOC_TEST:Axis1-MCU1-asyn
IOC_TEST:Axis1
```

## Motor record fields
```
ACCU: Accs          AMSG:               ASG :               ATHM: 1             
CDIR: 1             CNEN: Enable        DESC: MCU1025 Lower Axis (1)            
DHLM: 80            DIFF: -0.0146484375 DISA: 0             DISP: 0             
DISV: 1             DLLM: -50           DMOV: 1             DRBV: 0.0390625     
DVAL: 0.0244140625  HLM : 80            HLS : 0             LLM : -50           
LLS : 0             LVIO: 0             MOVN: 0             NAME: IOC_TEST:Axis1
NAMSG:              OFF : 0             RBV : 0.0390625     RDIF: -1            
REP : 0             RHLS: 0             RLLS: 0             RLV : 0             
RMP : 0             RRBV: 3             RVAL: 2             SEVR: NO_ALARM      
STAT: NO_ALARM      TDIR: 0             TPRO: 0             VAL : 0.0244140625  
VERS: 7.07          
mcag-dev-asm-02-18930 > dbpr IOC_TEST:Axis1 10
ACCL: 0.25          ACCS: 20            ACCU: Accs          ACKS: MAJOR         
ACKT: YES           ADEL: 0             AMSG:               ASG :               
ASP : PTR (nil)     ATHM: 1             BACC: 0.1           BDST: 0             
BKLNK: ELL 0 [(nil) .. (nil)]           BKPT: 00            BVEL: 0             
CARD: 0             CBAK: PTR 0x1d0b020 CDIR: 1             CNEN: Enable        
DCOF: 0             DESC: MCU1025 Lower Axis (1)            DHLM: 80            
DIFF: -0.0146484375 DINP: CONSTANT      DIR : Pos           DISA: 0             
DISP: 0             DISS: NO_ALARM      DISV: 1             DLLM: -50           
DLY : 0             DMOV: 1             DOL : CONSTANT      DPVT: PTR 0x1d0b830 
DRBV: 0.0390625     DSET: PTR 0x7f667d19b520                DTYP: asynMotor     
DVAL: 0.0244140625  EGU : mm            ERES: 0.0146484375  EVNT:               
FLNK: CONSTANT      FOF : 0             FOFF: Variable      FRAC: 1             
HHSV: NO_ALARM      HIGH: 0             HIHI: 0             HLM : 80            
HLS : 0             HLSV: NO_ALARM      HOMF: 0             HOMR: 0             
HOPR: 0             HSV : NO_ALARM      HVEL: 0             ICOF: 0             
IGSET: 0            INIT:               JAR : 20            JOGF: 0             
JOGR: 0             JVEL: 5             LCNT: 0             LLM : -50           
LLS : 0             LLSV: NO_ALARM      LOCK: NO            LOLO: 0             
LOPR: 0             LOW : 0             LSET: PTR 0x1c6c7c0 LSPG: Go            
LSV : NO_ALARM      LVIO: 0             MDEL: 0             MFLG: 63            
MIP : 0             MISS: 0             MISV: NO_ALARM      
MLIS: ELL 61 [0x1d5bc20 .. 0x1d5a1a8]   MLOK: e0 8d c7 01 00 00 00 00           
MMAP: 0             MOVN: 0             MRES: 0.0146484375  MSTA: 18730         
NAME: IOC_TEST:Axis1                    NAMSG:              NMAP: 0             
NSEV: NO_ALARM      NSTA: NO_ALARM      NTM : YES           NTMF: 2             
OFF : 0             OMSL: supervisory   OUT : INST_IO @asyn(MCU1,1)             
PACT: 0             PCOF: 0             PHAS: 0             PINI: NO            
POST:               PP  : 0             PPN : PTR (nil)     PPNR: PTR (nil)     
PREC: 3             PREM:               PRIO: LOW           PROC: 0             
PUTF: 0             RBV : 0.0390625     RCNT: 0             RDBD: 0.1           
RDBL: CONSTANT      RDES: PTR 0x179bcf0 RDIF: -1            REP : 0             
RHLS: 0             RINP: CONSTANT      RLLS: 0             RLNK: CONSTANT      
RLV : 0             RMOD: In-Position   RMP : 0             RPRO: 0             
RRBV: 3             RRES: 0             RSET: PTR 0x7f667d19b680                
RSTM: NearZero      RTRY: 1             RVAL: 2             RVEL: 0             
S   : 0.083333333333333                 SBAK: 0             SBAS: 0             
SCAN: Passive       SDIS: CONSTANT      SET : Use           SEVR: NO_ALARM      
SMAX: 0             SPAM: 15            SPDB: 0.1           SPMG: Go            
SPVT: PTR (nil)     SREV: 4096          SSET: 0             STAT: NO_ALARM      
STOO: CONSTANT      STOP: 0             STUP: OFF           SUSE: 0             
SYNC: 0             TDIR: 0             TIME: 2022-09-26 10:56:20.197118364     
TPRO: 0             TSE : 0             TSEL: CONSTANT      TWF : 0             
TWR : 0             TWV : 10            UDF : 0             UDFS: INVALID       
UEIP: No            UREV: 60            URIP: No            UTAG: 0             
VAL : 0.0244140625  VBAS: 0             VELO: 5             VERS: 7.07          
VMAX: 0             VOF : 0             priv: PTR 0x1d0b6e0 
```
