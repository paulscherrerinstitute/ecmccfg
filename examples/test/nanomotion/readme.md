# Notes

* Enable input is GND switching => Need special output card.. EL2084, EL2088...

* Velocity seems not to be linear with motion velo, drive scaling of 25mm/s for 32768 output seems to work for a target velo of 10mm/s, might need to be retuned if other velo is used..
* Works rather well!

# Equipment

## Drive 
Nanomotion AB5

## Motor 
P/N = HR2-1-S-3

## Encoder 
Jena LIK22-N12-P2
LIK = Linear incremental
22 = housing size
N = RS422 with Interpolation 10 times
1 = Customer specific
2 = Scanning head with M3 thread

Seems to have a resolution of 0.1micro meter (1mm/10000)

