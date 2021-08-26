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

#define LOG_TAG "SHIFT-LightExt"

#include <android-base/file.h>
#include <hardware/lights.h>
#include <log/log.h>

#include "LightExt.h"

namespace hardware {
namespace shift {
namespace light {
namespace V1_0 {
namespace implementation {

using ::hardware::shift::light::V1_0::Torch;

Return<Status> LightExt::applyTorchLight(Torch torch, const LightState& state) {
    bool on = (state.flashOnMs > 0);

    std::string torchZeroValue;
    std::string torchOneValue;
    switch(torch) {
        case Torch::ZERO: {
            ALOGD("Handling Torch::ZERO, on=%s", (on ? "true" : "false"));
            torchZeroValue = (on ? "100" : "0");
            torchOneValue = "0";
            break;
        }
        case Torch::ONE: {
            ALOGD("Handling Torch::ONE, on=%s", (on ? "true" : "false"));
            torchZeroValue = "0";
            torchOneValue = (on ? "100" : "0");
            break;
        }
        default: {
            ALOGD("Unknown torch, on=%s", (on ? "true" : "false"));
            torchZeroValue = "0";
            torchOneValue = "0";
            break;
        }
    }

    if (!android::base::WriteStringToFile(torchZeroValue, kTorchZeroBrightnessNode)) {
        ALOGE("Failed to write to torch zero brightness node!");
        return Status::UNKNOWN;
    }
    if (!android::base::WriteStringToFile(torchOneValue, kTorchOneBrightnessNode)) {
        ALOGE("Failed to write to torch one brightness node!");
        return Status::UNKNOWN;
    }
    if (!android::base::WriteStringToFile((on ? "1" : "0"), kSwitchBrightnessNode)) {
        ALOGE("Failed to write to switch brightness node!");
        return Status::UNKNOWN;
    }

    if (!on) {
        if (!android::base::WriteStringToFile("torch0_trigger", kTorchZeroTriggerNode)) {
            ALOGE("Failed to write to torch zero trigger node!");
            return Status::UNKNOWN;
        }
        if (!android::base::WriteStringToFile("torch1_trigger", kTorchOneTriggerNode)) {
            ALOGE("Failed to write to torch one trigger node!");
            return Status::UNKNOWN;
        }
    }

    return Status::SUCCESS;
}

// Methods from ::android::hardware::light::V2_0::ILight follow.
Return<Status> LightExt::setLight(Type type, const LightState& state) {
    return mLight->setLight(type, state);
}

// Methods from ::hardware::shift::light::V1_0::ILight follow.
Return<Status> LightExt::setTorchLight(Torch torch, const LightState& state) {
    ALOGD("setTorchLight");

    if (!mHasSwitchNode) return Status::UNKNOWN;
    if (!mHasTorchZeroNode) return Status::UNKNOWN;
    if (!mHasTorchOneNode) return Status::UNKNOWN;

    return applyTorchLight(torch, state);
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace light
}  // namespace shift
}  // namespace hardware
