/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "hardware.shift.light-service.default"

#include "LightsExt.h"

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/strings.h>
#include <android/binder_status.h>
#include <fstream>
#include "android/binder_auto_utils.h"

namespace aidl {
namespace hardware {
namespace shift {
namespace light {

static bool fileExists(const std::string& path) {
    if (path.empty()) {
        return false;
    }

    int retries = 10;

    while (retries--) {
        android::base::unique_fd fd(TEMP_FAILURE_RETRY(open(path.c_str(), O_RDWR)));

        if (fd > -1) {
            return true;
        }

        usleep(100000);
    }

    return false;
}

static const std::string kSwitchBrightnessNode = "/sys/class/leds/led:switch_0/brightness";

static const std::vector<TorchNode> kTorchNodes = {
        {0, TorchType::COLD, "/sys/class/leds/led:torch_0/brightness",
         "/sys/class/leds/led:torch_0/max_brightness", "/sys/class/leds/led:torch_0/trigger"},
        {1, TorchType::WARM, "/sys/class/leds/led:torch_1/brightness",
         "/sys/class/leds/led:torch_1/max_brightness", "/sys/class/leds/led:torch_1/trigger"},
};

LightsExt::LightsExt() {
    for (const auto& node : kTorchNodes) {
        if (!fileExists(node.brightnessPath) || !fileExists(node.brightnessMaxPath) ||
            !fileExists(node.triggerPath)) {
            continue;
        }

        std::string maxBrightnessStr;
        if (!android::base::ReadFileToString(node.brightnessMaxPath, &maxBrightnessStr, true)) {
            LOG(ERROR) << "Failed to read max brightness value value for torch with id " << node.id;
            continue;
        }
        maxBrightnessStr = android::base::Trim(maxBrightnessStr);

        Torch torch;
        torch.id = node.id;
        torch.type = node.type;
        torch.maxBrightness = std::stoi(maxBrightnessStr);
        mTorches.push_back(torch);
    }

    // If there are at least 2 torches, add a logical torch node
    const int torchCount = mTorches.size();
    if (torchCount >= 2) {
        Torch logicalTorch;
        logicalTorch.id = torchCount;
        logicalTorch.type = TorchType::NORMAL;
        logicalTorch.maxBrightness = 100;
        mTorches.push_back(logicalTorch);
    }
}

ndk::ScopedAStatus LightsExt::setTorchState(const Torch& in_torch, const TorchState& in_state) {
    bool on = (in_state.brightness > 0);

    std::string torchZeroValue;
    std::string torchOneValue;
    switch (in_torch.id) {
        case 0: {
            LOG(DEBUG) << "Handling Torch::ZERO, on=" << (on ? "true" : "false");
            torchZeroValue = (on ? "100" : "0");
            torchOneValue = "0";
            break;
        }
        case 1: {
            LOG(DEBUG) << "Handling Torch::ONE, on=" << (on ? "true" : "false");
            torchZeroValue = "0";
            torchOneValue = (on ? "100" : "0");
            break;
        }
        case 2: {
            LOG(DEBUG) << "Handling logical torch, on=" << (on ? "true" : "false");
            torchZeroValue = (on ? "100" : "0");
            torchOneValue = (on ? "100" : "0");
            break;
        }
        default: {
            LOG(ERROR) << "Unknown torch, on=" << (on ? "true" : "false");
            return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
        }
    }

    if (!android::base::WriteStringToFile(torchZeroValue, kTorchNodes[0].brightnessPath)) {
        LOG(ERROR) << "Failed to write to torch zero brightness node!";
        return ndk::ScopedAStatus::fromExceptionCode(EX_ILLEGAL_STATE);
    }
    if (!android::base::WriteStringToFile(torchOneValue, kTorchNodes[1].brightnessPath)) {
        LOG(ERROR) << "Failed to write to torch one brightness node!";
        return ndk::ScopedAStatus::fromExceptionCode(EX_ILLEGAL_STATE);
    }
    if (!android::base::WriteStringToFile((on ? "1" : "0"), kSwitchBrightnessNode)) {
        LOG(ERROR) << "Failed to write to switch brightness node!";
        return ndk::ScopedAStatus::fromExceptionCode(EX_ILLEGAL_STATE);
    }

    if (!on) {
        if (!android::base::WriteStringToFile("torch0_trigger", kTorchNodes[0].triggerPath)) {
            LOG(ERROR) << "Failed to write to torch zero trigger node!";
            return ndk::ScopedAStatus::fromExceptionCode(EX_ILLEGAL_STATE);
        }
        if (!android::base::WriteStringToFile("torch1_trigger", kTorchNodes[1].triggerPath)) {
            LOG(ERROR) << "Failed to write to torch one trigger node!";
            return ndk::ScopedAStatus::fromExceptionCode(EX_ILLEGAL_STATE);
        }
    }
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus LightsExt::getTorches(std::vector<Torch>* torches) {
    for (const auto& torch : mTorches) {
        torches->push_back(torch);
    }
    return ndk::ScopedAStatus::ok();
}

binder_status_t LightsExt::dump(int fd, const char** /* args */, uint32_t /* numArgs */) {
    std::vector<Torch> torches;
    getTorches(&torches);

    dprintf(fd, "Torches:\n");
    for (const auto& torch : torches) {
        dprintf(fd, "\t- ID: %d, Type: %s, Max Brightness: %d\n", torch.id,
                toString(torch.type).c_str(), torch.maxBrightness);
    }

    return STATUS_OK;
}

}  // namespace light
}  // namespace shift
}  // namespace hardware
}  // namespace aidl
