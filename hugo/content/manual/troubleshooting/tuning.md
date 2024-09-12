+++  
title = "tuning"   
weight = 15
chapter = false  
+++

***

### EL70x1 Tuning

For EL70x1 stepper drives the following parameters can be tuned:
* 8011:07 Ka factor 
* 8011:08 Kd factor
* 8011:01 Kp factor
* 8011:02 Ki factor

#### 8011:07 Ka and 8011:08 Kd factor:

8011:07 Ka factor / 8011:08 Kd factor are “current boosts” during acceleration/deceleration.
Default they are set to 100% which is way too high for most applications. Start by setting these parameters to 0.
    
#### 8011:01 Kp  and 8011:02 Ki factor:
This is the current loop settings and this is also what affect the performance. The higher you set these registers, the stiffer the control loop.
For most applications it is important to keep a ration of 40:1.
Default is 400 / 10, if you want a stiffer loop, then change to f ex 800 / 20 and onwards.
Increase until the motor misbehaves and go back to a safe setting.

