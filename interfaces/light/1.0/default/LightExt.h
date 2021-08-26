/*
 * Copyright (C) 2020 SHIFT GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef HARDWARE_SHIFT_LIGHT_V1_0_LIGHT_H
#define HARDWARE_SHIFT_LIGHT_V1_0_LIGHT_H

#include <hidl/Status.h>
#include <string>

#include <hidl/MQDescriptor.h>
#include <hardware/shift/light/1.0/ILight.h>
#include "Light.h"

namespace hardware {
namespace shift {
namespace light {
namespace V1_0 {
namespace implementation {

using ::android::hardware::Return;
using ::android::hardware::light::V2_0::LightState;
using ::android::hardware::light::V2_0::Status;
using ::android::hardware::light::V2_0::Type;
using ::hardware::shift::light::V1_0::Torch;
using HwILight = ::android::hardware::light::V2_0::ILight;

constexpr const char kSwitchBrightnessNode[] =
    "/sys/class/leds/led:switch_0/brightness";

constexpr const char kTorchZeroBrightnessNode[] =
    "/sys/class/leds/led:torch_0/brightness";

constexpr const char kTorchZeroTriggerNode[] =
    "/sys/class/leds/led:torch_0/trigger";

constexpr const char kTorchOneBrightnessNode[] =
    "/sys/class/leds/led:torch_1/brightness";

constexpr const char kTorchOneTriggerNode[] =
    "/sys/class/leds/led:torch_1/trigger";

class LightExt : public ::hardware::shift::light::V1_0::ILight {
  public:
    LightExt(HwILight*&& light) : mLight(light) {
        mHasSwitchNode = !access(kSwitchBrightnessNode, F_OK);
        mHasTorchZeroNode = !access(kTorchZeroBrightnessNode, F_OK) && !access(kTorchZeroTriggerNode, F_OK);
        mHasTorchOneNode = !access(kTorchOneBrightnessNode, F_OK) && !access(kTorchOneTriggerNode, F_OK);
    };

    // Methods from ::android::hardware::light::V2_0::ILight follow.
    Return<Status> setLight(Type type, const LightState& state) override;
    Return<void> getSupportedTypes(getSupportedTypes_cb _hidl_cb) override {
        return mLight->getSupportedTypes(_hidl_cb);
    }

    // Methods from ::hardware::shift::light::V1_0::ILight follow.
    Return<Status> setTorchLight(Torch torch, const LightState& state) override;

  private:
    std::unique_ptr<HwILight> mLight;
    Return<Status> applyTorchLight(Torch torch, const LightState& state);
    bool mHasSwitchNode = false;
    bool mHasTorchZeroNode = false;
    bool mHasTorchOneNode = false;
};

}  // namespace implementation
}  // namespace V1_0
}  // namespace light
}  // namespace shift
}  // namespace hardware

#endif  // HARDWARE_SHIFT_LIGHT_V1_0_LIGHT_H
