/*************************************************************************\
* Copyright (c) 2026 Paul Scherrer Institute
* ecmc is distributed subject to a Software License Agreement found
* in file LICENSE that is included with this distribution.
*
*  main.cpp
*
*  Minimal example for the additive C++ logic interface in ecmc.
*
\*************************************************************************/

#include "ecmcCppLogic.hpp"

#include <cstdint>
#include <string>

struct NativeBounceLogic : public ecmcCpp::LogicBase {
  static constexpr uint16_t lower_turnaround_position {100};
  static constexpr uint16_t upper_turnaround_position {12800};

  std::string slave_id {"14"};
  uint16_t actual_position {0};
  uint16_t drive_control {0};
  int16_t velocity_setpoint {1000};
  int32_t cycle_counter {0};

  NativeBounceLogic() {
    slave_id = ecmcCpp::getMacroValueString(ecmcCpp::getMacrosString(), "S_ID", "14");
    const std::string item_base = "ec.s" + slave_id + ".";
    const std::string actual_position_item = item_base + "positionActual01";
    const std::string drive_control_item = item_base + "driveControl01";
    const std::string velocity_setpoint_item = item_base + "velocitySetpoint01";

    ecmc.input(actual_position_item, actual_position)
        .output(drive_control_item, drive_control)
        .output(velocity_setpoint_item, velocity_setpoint);

    ecmcCpp::setEnableDbg(true);

    epics.readOnly("main.actual_position", actual_position)
         .readOnly("main.cycle_counter", cycle_counter)
         .writable("main.velocity_setpoint", velocity_setpoint);
  }

  int32_t validateCreation(std::string* errorMessage) {
    if (slave_id.empty()) {
      if (errorMessage) {
        *errorMessage = "S_ID macro must not be empty";
      }
      return ECMC_CPP_LOGIC_CREATE_INSTANCE_FAIL;
    }
    return 0;
  }

  void run() override {
    cycle_counter += 1;
    drive_control = 0x0001;

    if (velocity_setpoint == 0) {
      velocity_setpoint = 1000;
    }
    if (actual_position <= lower_turnaround_position) {
      velocity_setpoint = 1000;
    } else if (actual_position >= upper_turnaround_position) {
      velocity_setpoint = -1000;
    }

    if ((cycle_counter % 1000) == 0) {
      ecmcCpp::publishDebugText("cpp logic example running");
    }
  }
};

ECMC_CPP_LOGIC_REGISTER_DEFAULT(NativeBounceLogic)
