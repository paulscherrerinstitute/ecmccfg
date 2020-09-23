# Filtering of encoder act position

In this directory two examples of how to filter actual encoder values are presented:

1. Use of data storage and simulated ec entry

2. Use of virt axis and data storage

Both filter the encoder value of the axis but both examples have some restictions:

1. Over/underflow of encoder data is not handled. As a workaround try to avoid over/underflow. For instance if possible then choose 32bit encoder value instead of 16bits..

2. Homing will not work.

## Future work:
Possability to filter actual value should be added to ecmc to avoid the above workarounds..
