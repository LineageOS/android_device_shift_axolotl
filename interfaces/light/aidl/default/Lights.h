/*
 * Copyright (C) 2019 The Android Open Source Project
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

#include <aidl/android/hardware/light/BnLights.h>
#include <mutex>
#include <vector>

using ::aidl::android::hardware::light::HwLight;
using ::aidl::android::hardware::light::HwLightState;

namespace aidl {
namespace android {
namespace hardware {
namespace light {

// Default implementation that reports no supported lights.
class Lights : public BnLights {
  public:
    Lights();

    ndk::ScopedAStatus setLightState(int id, const HwLightState& state) override;
    ndk::ScopedAStatus getLights(std::vector<HwLight>* types) override;

  private:
    ndk::ScopedAStatus handleBacklight(const HwLightState& state);
    ndk::ScopedAStatus handleRgb(const HwLightState& state, size_t index);

    std::mutex mLock;
    std::vector<HwLight> mLights;
    std::array<HwLightState, 3> mLightStates;
};

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
