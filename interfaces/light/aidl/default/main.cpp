/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "Lights.h"
#include "LightsExt.h"

#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

using Lights = ::aidl::android::hardware::light::Lights;
using LightsExt = ::aidl::hardware::shift::light::LightsExt;

int main() {
    ABinderProcess_setThreadPoolMaxThreadCount(0);

    // Core service
    std::shared_ptr<Lights> lights = ndk::SharedRefBase::make<Lights>();
    ndk::SpAIBinder lightsBinder = lights->asBinder();

    // Extension service
    std::shared_ptr<LightsExt> lightsExt = ndk::SharedRefBase::make<LightsExt>();

    // Attach extension to core service
    CHECK(STATUS_OK == AIBinder_setExtension(lightsBinder.get(), lightsExt->asBinder().get()));

    // Register core service
    const std::string instance = std::string() + Lights::descriptor + "/default";
    CHECK(STATUS_OK == AServiceManager_addService(lightsBinder.get(), instance.c_str()));

    ABinderProcess_joinThreadPool();
    return EXIT_FAILURE;  // should not reach
}
