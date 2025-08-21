# Advanced demo of a 2 axes slit system

## Hardware
This demo is based on a ESS MCU1025 2 axis crate

## Axes

1. Slit center position (virt)
2. Slit gap/opening (virt)
3. Right blade (normal)
4. Left blade (normal)
5. Timing (virt), connected to signal generator or timing system
6. Amplitude

Both gap and position are configuerd to oscillate in sinus. with freq. set by axis 5 and amplitude defined by axis 6.
The deom also includes temperature and vibration monitoring of the motors through el3214 and el2632.


# TODO
Consider adding softlimit support like in the simpler demo
