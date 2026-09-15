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

struct MiniEL1252Example : public ecmcCpp::LogicBase {

  std::string slave_id {"14"};
  uint64_t timestampLatchPositive01 {0};
  uint64_t cycle_counter {0};

  MiniEL1252Example() {
    // Get MACRO "S_ID" from macros string (ecmcCpp::getMacrosString()), if S_ID is not defined it will be set to 5
    slave_id = ecmcCpp::getMacroValueString(ecmcCpp::getMacrosString(), "S_ID", "5");
    const std::string item_base = "ec.s" + slave_id + ".";
    const std::string ts_pos_edge_01_item = item_base + "timestampLatchPositive01";

    // link ecmc ec.s<S_ID>.timestampLatchPositive01 param to variable timestampLatchPositive01
    ecmc.input(ts_pos_edge_01_item, timestampLatchPositive01);

    // expose timestampLatchPositive01 to epics over asynport CPP.<ASYN_PORT> with param name "main.timestampLatchPositive01"
    epics.readOnly("main.timestampLatchPositive01", timestampLatchPositive01);

    // Enable DBG text tp EPICS waveform PV
    ecmcCpp::setEnableDbg(true);
  }

  // validate macros
  int32_t validateCreation(std::string* errorMessage) {
    if (slave_id.empty()) {
      if (errorMessage) {
        *errorMessage = "S_ID macro must not be empty";
      }
      return 1; //ECMC_CPP_LOGIC_CREATE_INSTANCE_FAIL;
    }
    return 0;
  }

  // runtime code executed in the seired rate in sync with ecmc RT thread
  void run() override {
    cycle_counter += 1;

    if ((cycle_counter % 1000) == 0) {
      ecmcCpp::publishDebugText("cpp logic example running");
      std::cout << "Timestamp: "  << timestampLatchPositive01 << " (slave Id: " <<  slave_id << ")\n";
    }
  }
};

ECMC_CPP_LOGIC_REGISTER_DEFAULT(MiniEL1252Example)
