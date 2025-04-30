# CSV openloop 20250407

Do not use EL7062 in CSV mode openloop!!!!! 

The EL7062 has a rather sever bug when running openloop CSV.
When the drive is disabled the openloop counter jumps to closest full turn (one turn is 1048576counts, 20bits).

How to reproduce:
* Start ioc (hardware is reset to default state)
* Enable axis
* move to a position within a turn
* Disable axis
* The actual position of the motor now jumps to closes fill turn (n*1048576)

Bug is reported to Beckhoff.


