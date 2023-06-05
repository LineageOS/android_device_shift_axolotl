/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

#include <aidl/hardware/shift/light/BnLights.h>

#include <android/binder_status.h>
#include <string>
#include "android/binder_auto_utils.h"

namespace aidl {
namespace hardware {
namespace shift {
namespace light {

struct TorchNode {
    const int id;
    const TorchType type;
    const std::string brightnessPath;
    const std::string brightnessMaxPath;
    const std::string triggerPath;
};

struct LightsExt : public BnLights {
  public:
    LightsExt();

    ndk::ScopedAStatus setTorchState(const Torch& in_torch, const TorchState& in_state) override;
    ndk::ScopedAStatus getTorches(std::vector<Torch>* torches) override;

    binder_status_t dump(int fd, const char** args, uint32_t numArgs) override;

  private:
    std::vector<Torch> mTorches;
};

}  // namespace light
}  // namespace shift
}  // namespace hardware
}  // namespace aidl
