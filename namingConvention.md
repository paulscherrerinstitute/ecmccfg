# Naming convention to consider for different institutions

## generic

### ECMC internal variables

* Use camelCase for the naming of the internal variables.
This affects mostly the hardware defintion files in `$ROOT/hardware/*`
* Variables must start with the decripition followed by the index.
The description might also represents the data type, i.e. analog, binary, posAct, setPos, timeStamp, ...
* Since many EtherCAT slaves have multiple input channels, _ALL_ channels will be given an index.
The index starts Fortran-style at `1`.
The index is of decimal type with two (2) zero padded digits to accomodate slaves with upto 99 inputs.
* In case the slave has a generic registers, those do _not_ feature an index.
See examples below for clarification.

#### Examples

* EL1008, 8 channel digital input

  * Channel 7
  
  | old         | new |
  |--           |--|
  |BI_7         |binary07 |
  
  Assuming this is slave 103 on the first master it would translate into `ec0.s103.binary07` internally for binary input 7.

* EL3164, 4 channel 16bit analog input (0--10V)

  * Channel 1
  
  | old         | new |
  |--           |--|
  |CH1_STATUS   |status01 |
  |CH1_VALUE    |analog01  |
  
  Assuming this is slave 42 on the first master it would translate into `ec0.s42.analog01` internally for the value channel.
  
* EL5002, 2 channel SSI encoder interface

  * Channel 2
  
  | old         | new |
  |--           |--|
  |CH2_STATUS   |status02 |
  |CH2_VALUE    |posAct02  |
  
  assuming this is slave 23 on the second master it would translate into `ec1.s23.posAct02` internally for the status information.

* Keyence DL-EC1A, max 15 channel, EtherCAT Compatible Network Unit for High-Accuracy Digital Contact Sensors

  * generic
  
  | old         | new |
  |--           |--|
  |INP_REQ1     |requestInp |
  |DEV_STATUS   |status |
  |DEV_ERR_CODE |errCode  |

  * Channel 13
  
  | old         | new |
  |--           |--|
  |CH13_STATUS  |status13 |
  |CH13_VALUE   |posAct13  |
  
  assuming this is slave 17 on the third master it would translate into `ec2.s17.errCode` internally for the error code information of the main unit.
  The actual data of the 8th input will reside under `ec2.s17.posAct13`.


## ESS

## PSI

PSI naming convention for SLS-2.0 is not definitive yet (2020-11-16).
However, certain constrains can be derived from previous conventions and facilities in operation.
The PV names will comprise of a `PREFIX` terminated by a colon `:`, followed by device specific information.
A single colon (`:`) is allowed in the names.
The amount of special characters should be reduced to an absolute minimum.
At all cost the use of brackets and braces has to be avoided, even though EPICS allows such characters in PV names.
The PV names have to be descriptive and allow for changes in the system, w/o braking any dependicies.
It has to be kept in mind that potentially many clients connect to an IOC, w/o the initial integrator knowing thereof!
