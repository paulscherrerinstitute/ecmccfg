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
#include <iostream>

struct NativeBounceLogic : public ecmcCpp::LogicBase {

  std::string slave_id {"14"};
  uint64_t timestampLatchPositive01 {0};
  uint64_t cycle_counter {0};

  NativeBounceLogic() {
    slave_id = ecmcCpp::getMacroValueString(ecmcCpp::getMacrosString(), "S_ID", "5");
    const std::string item_base = "ec.s" + slave_id + ".";
    const std::string ts_pos_edge_01_item = item_base + "timestampLatchPositive01";

    ecmc.input(ts_pos_edge_01_item, timestampLatchPositive01);
    epics.readOnly("main.timestampLatchPositive01", timestampLatchPositive01);
    ecmcCpp::setEnableDbg(true);
  }

  int32_t validateCreation(std::string* errorMessage) {
    if (slave_id.empty()) {
      if (errorMessage) {
        *errorMessage = "S_ID macro must not be empty";
      }
      return 1; //ECMC_CPP_LOGIC_CREATE_INSTANCE_FAIL;
    }
    return 0;
  }

  void run() override {
    cycle_counter += 1;

    if ((cycle_counter % 1000) == 0) {
      ecmcCpp::publishDebugText("cpp logic example running");
      std::cout << "Timestamp: "  << timestampLatchPositive01 << "\n";
    }
  }
};

ECMC_CPP_LOGIC_REGISTER_DEFAULT(NativeBounceLogic)
