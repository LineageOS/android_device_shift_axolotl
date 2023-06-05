/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "SHIFT_light_aidl_hal_test"

#include <aidl/Gtest.h>
#include <aidl/Vintf.h>

#include <aidl/android/hardware/light/ILights.h>
#include <aidl/hardware/shift/light/ILights.h>
#include <aidl/hardware/shift/light/Torch.h>
#include <aidl/hardware/shift/light/TorchState.h>
#include <aidl/hardware/shift/light/TorchType.h>
#include <android/binder_manager.h>
#include <android/binder_status.h>
#include <binder/ProcessState.h>
#include <gtest/gtest.h>

using ILights = ::aidl::android::hardware::light::ILights;
using ILightsExt = ::aidl::hardware::shift::light::ILights;

using ::aidl::hardware::shift::light::Torch;
using ::aidl::hardware::shift::light::TorchState;
using ::aidl::hardware::shift::light::TorchType;
using android::ProcessState;
using ndk::SpAIBinder;

static const std::string kInstance = std::string() + ILights::descriptor + "/default";

const std::set<TorchType> kAllTorchTypes{ndk::enum_range<TorchType>().begin(),
                                    ndk::enum_range<TorchType>().end()};

class SHIFT_LightsAidl : public testing::TestWithParam<std::string> {
  public:
    virtual void SetUp() override {
        // Get core service
        lightsBinder = SpAIBinder(AServiceManager_getService(kInstance.c_str()));
        ASSERT_NE(nullptr, lightsBinder.get());

        // Get extension from core service
        ASSERT_EQ(STATUS_OK, AIBinder_getExtension(lightsBinder.get(), lightsExtBinder.getR()));
        ASSERT_NE(nullptr, lightsExtBinder.get());

        lightsExt = ILightsExt::fromBinder(lightsExtBinder);
        ASSERT_NE(nullptr, lightsExt.get());

        // Get supported torches
        ASSERT_TRUE(lightsExt->getTorches(&supportedTorches).isOk());
    }

    SpAIBinder lightsBinder;
    SpAIBinder lightsExtBinder;

    std::shared_ptr<ILightsExt> lightsExt;
    std::vector<Torch> supportedTorches;

    virtual void TearDown() override {
        for (const Torch& torch : supportedTorches) {
            TorchState off;
            off.brightness = 0;
            EXPECT_TRUE(lightsExt->setTorchState(torch, off).isOk());
        }
    }
};

/**
 * Ensure all reported torches actually work.
 */
TEST_P(SHIFT_LightsAidl, TestSupported) {
    TorchState on;
    for (const Torch& torch : supportedTorches) {
        EXPECT_TRUE(torch.maxBrightness > 0);

        on.brightness = torch.maxBrightness;
        EXPECT_TRUE(lightsExt->setTorchState(torch, on).isOk());
    }

    TorchState off;
    off.brightness = 0;
    for (const Torch& torch : supportedTorches) {
        EXPECT_TRUE(lightsExt->setTorchState(torch, off).isOk());
    }
}

/**
 * Ensure all reported torches have one of the supported types.
 */
TEST_P(SHIFT_LightsAidl, TestSupportedTorchTypes) {
    for (const Torch& torch : supportedTorches) {
        EXPECT_TRUE(kAllTorchTypes.find(torch.type) != kAllTorchTypes.end());
    }
}

/**
 * Ensure all torches have a unique id.
 */
TEST_P(SHIFT_LightsAidl, TestUniqueIds) {
    std::set<int> ids;
    for (const Torch& torch : supportedTorches) {
        EXPECT_TRUE(ids.find(torch.id) == ids.end());
        ids.insert(torch.id);
    }
}

/**
 * Ensure EX_UNSUPPORTED_OPERATION is returns for an invalid torch.
 */
TEST_P(SHIFT_LightsAidl, TestInvalidTorchUnsupported) {
    Torch invalidTorch;
    invalidTorch.id = -1;

    auto status = lightsExt->setTorchState(invalidTorch, TorchState());
    EXPECT_TRUE(status.getExceptionCode() == EX_UNSUPPORTED_OPERATION);
}

/**
 * Ensure a logical torch is reported if there are at least two torches.
 */
TEST_P(SHIFT_LightsAidl, TestLogicalTorchReported) {
    const auto supportedTorchCount = supportedTorches.size();
    EXPECT_FALSE(supportedTorchCount == 2);

    if (supportedTorchCount < 2) {
        GTEST_SKIP() << "Only a single torch supported";
        return;
    }

    EXPECT_TRUE(kAllTorchTypes.find(TorchType::NORMAL) != kAllTorchTypes.end());
}

GTEST_ALLOW_UNINSTANTIATED_PARAMETERIZED_TEST(SHIFT_LightsAidl);
INSTANTIATE_TEST_SUITE_P(SHIFT_Lights, SHIFT_LightsAidl,
                         testing::ValuesIn(android::getAidlHalInstanceNames(ILightsExt::descriptor)),
                         android::PrintInstanceNameToString);

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    ProcessState::self()->setThreadPoolMaxThreadCount(1);
    ProcessState::self()->startThreadPool();
    return RUN_ALL_TESTS();
}
