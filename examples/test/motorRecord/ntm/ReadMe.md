# NTM (New Target Monitor) field

From docs:

The requirements on how the motor record processes a new target position while the motor is in motion are as follows;

Case #1: The motor record is given a new position, which is in the opposite direction from the current motor motion. If NTM is "YES", the motor is immediately stopped and given a motion command to the new position. If NTM is "NO ", the motor completes the previous move before it is given a motion command to the new position.

Case #2: The motor record is given a new position, which is in the same direction as the current motor motion, but the new position is closer to the motor's current position than the original target position. If NTM is "YES", the motor is stopped after it has gone past the new position; then a command is given to return to the new position. If NTM is "NO", the motor completes the previous move before it is given a motion command to the new position.

Case #3: The motor record is given a new position, which is in the same direction as the current motor motion, but the new position is further from the motor's current position than the original position. After the motor reaches the original target position and stops, a command is given to the new target position. This case is independent of NTM.
NTM defaults to "YES". It should be set to "NO" only for soft motors. Soft motors should be configured with NTM set to "NO" to prevent Case #1 above from interfering with "hard" motors using backlash correction.


## Case 1 NTM = YES
The motor record is given a new position, which is in the opposite direction from the current motor motion.

Test:
* target positon        = 70
* new target positon    = 40
* actual positon (when enter new target position) = 50

Works sometimes but atleast one BUGG:

if the new target position is the same as the starting target position it will not work. This will not work:

* original target position = 40
* target positon        = 70
* new target positon    = 40
* actual positon (when enter new targey position) = 50

so "new target positon" needs to differ from "original target position"..

if "new target positon" == "original target position" then motion will just stop. However when trying to move to a new positoin it will go to "new target positon" independent on which target position was entered.

Same issue is both directions.


## Case 1 NTM = NO

Test:
* target positon        = 30
* new target positon    = 0
* actual positon (when enter new target position) = 10

The motion will be completed to the "target position" and then a new motion command will be issued to the "new target position"

Same issue as with NTM==YES. IF "new target position" == "original target position" then the motion to the new target position will not be triggered.

Same issue is both directions.

## NTM = YES new target position > actual position

Motor moves to old targetpos and stops then a new motion is initialized to the new target position
