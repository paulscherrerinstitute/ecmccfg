/*************************************************************************\
* Copyright (c) 2026 Paul Scherrer Institute
* ecmc is distributed subject to a Software License Agreement found
* in file LICENSE that is included with this distribution.
*
*  main.cpp
*
*  C++ logic example using the control and utility helper headers.
*
\*************************************************************************/

#include "ecmcCppControl.hpp"
#include "ecmcCppLogic.hpp"
#include "ecmcCppUtils.hpp"

struct SimpleControlExample : public ecmcCpp::LogicBase {
  uint16_t actual_position_raw {0};
  double setpoint_position {5000.0};
  int16_t raw_velocity_cmd {0};
  int16_t drive_control {0};

  ecmcCpp::Pid position_pid;
  ecmcCpp::RateLimiter velocity_ramp;
  ecmcCpp::HysteresisBool in_position;

  SimpleControlExample() {
    // link some ecmc ethercat params to local variables
    ecmc.input("ec.s14.positionActual01", actual_position_raw)
        .output("ec.s14.driveControl01", drive_control)
        .output("ec.s14.velocitySetpoint01", raw_velocity_cmd);

    // expose some variables to epics over ASYN_PORT, default CPP.LOGIC<index>
    epics.writable("control.setpoint_position", setpoint_position)
         .readOnly("control.actual_position", actual_position_raw)
         .readOnly("control.raw_velocity_cmd", raw_velocity_cmd)
         .readOnly("control.in_position", in_position.Out);

    // inits
    position_pid.Kp = 2.0;
    position_pid.Ki = 0.0;
    position_pid.Kd = 0.0;
    position_pid.OutMin = -2000.0;
    position_pid.OutMax = 2000.0;

    velocity_ramp.RisingRate = 10000.0;
    velocity_ramp.FallingRate = 10000.0;

    in_position.Low = -5.0;
    in_position.High = 5.0;
  }

  // run in sync with ecmc rt thread
  void run() override {
    drive_control = 0x0001;

    position_pid.Setpoint = setpoint_position;
    position_pid.Actual = actual_position_raw;
    position_pid.run();
    raw_velocity_cmd = position_pid.Output;

    velocity_ramp.Input = raw_velocity_cmd;
    velocity_ramp.run();
    raw_velocity_cmd = velocity_ramp.Output;

    in_position.In = setpoint_position - actual_position_raw;
    in_position.run();
  }
};

ECMC_CPP_LOGIC_REGISTER_DEFAULT(SimpleControlExample)
