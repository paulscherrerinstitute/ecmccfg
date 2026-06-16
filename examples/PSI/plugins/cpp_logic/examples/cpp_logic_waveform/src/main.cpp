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

#include <array>
#include <cstdint>
#include <string>

struct WaveformGenerator : public ecmcCpp::LogicBase {
  std::array<int16_t, 100> samples {};
  std::string slave_id {"14"};
  std::string ch_id {"01"};
  int cycle_counter {0};
  
  WaveformGenerator() {
    slave_id = ecmcCpp::getMacroValueString(ecmcCpp::getMacrosString(), "S_ID", "14");
    ch_id = ecmcCpp::getMacroValueString(ecmcCpp::getMacrosString(), "CH_ID", "01");
    const std::string item_base = "ec.s" + slave_id + ".";
    const std::string waveformEcPath = item_base + "mm.analogOutputArray" + ch_id;
    ecmc.outputArray(waveformEcPath, samples);
    epics.readOnlyArray("epics_ec.s23.mm.analogOutputArray01", samples);

    ecmcCpp::setEnableDbg(true);

  }

  void run() override {
    cycle_counter += 1;

    if ((cycle_counter % 1000) == 0) {
      ecmcCpp::publishDebugText("cpp waveform logic example running");
    }
  }
};

ECMC_CPP_LOGIC_REGISTER_DEFAULT(WaveformGenerator)
