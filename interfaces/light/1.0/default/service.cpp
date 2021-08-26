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

#define LOG_TAG "hardware.shift.light@1.0-service"

#include <android-base/logging.h>
#include <hidl/HidlTransportSupport.h>

#include "Light.h"
#include "LightExt.h"

using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;

using android::hardware::light::V2_0::implementation::Light;
using hardware::shift::light::V1_0::ILight;
using hardware::shift::light::V1_0::implementation::LightExt;

int main() {
    ALOGI("SHIFT Light HAL service is starting up");

    android::sp<ILight> service = new LightExt(new Light());

    configureRpcThreadpool(1, true);

    android::status_t status = service->registerAsService();
    if (status != android::OK) {
        LOG(ERROR) << "Cannot register Light HAL service.";
        return 1;
    }

    LOG(INFO) << "SHIFT Light HAL service ready.";

    joinRpcThreadpool();

    LOG(ERROR) << "SHIFT Light HAL service failed to join thread pool.";
    return 1;
}
