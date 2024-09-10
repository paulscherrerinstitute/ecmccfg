+++  
title = "hardware"   
weight = 11
chapter = false  
+++

### Hardware

### Over current protection EL9227-5500, EL9221-5000
In the standard setup at PSI over current protection modules are used to feed 24V to both the ethercat communication bus (E-bus) and the power bus of the etehrcat slaves. If the over current protection is not enabled then the ethercat slaves will not receive power.

First time, (and only first time), a system is in use, the overcurrent modules needs to be enabled in order to allow current to flow. Enabling is done by push buttons in the LED area of the module. The long horizontal LEDs are in fact buttons that can be used to activate or tripp the over current protection. The EL9221-5000 has one channel and can therefore only the top button is needed to be pressed. The EL9227-5500 is a 2 channel module and normally both channels needs to be enabled by pressing both the top and bottom long LED. if only one are pressed it could result in that the power to the communication is fine but the power to the i/o bus is lacking. This can result in starnge issues. Both EL9227-5500 and EL9221-5000 have dedicated panels whre status of the over current protection can be seen.

