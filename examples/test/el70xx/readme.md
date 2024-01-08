# test scripts for EL70xx
All test for EL70xx is in this dir


# high speed tests:
Test to see if el70x7 is better than el70x1 when it comes to running at higher speeds
The background is that ESS have seen significant differences with EL7047 vs EL7041-0052, where EL7047 was more forgiving and allowed higher speeds without special tuning.

## el7037 vs el7031
* Oriental motor PK267JB

### Test without inertia or damper

El7037 slightly better:
* EL7031 stalls at 1400 deg/s
* EL7037 stalls ar 1550 deg/s

### Test with el7041-0052
* Phytron ZSH 1.57.200.4
Without inertia or damper stalls at apporx 1400 deg/s
With damper can to up to very high speeds (tested 130Hz=36800deg/s) without stall so even higher possible. 


