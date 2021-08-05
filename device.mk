#
# Copyright 2021 SHIFT GmbH
# Copyright 2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product-if-exists, vendor/shift/axolotl/device-vendor.mk)

# AVB
#BOARD_AVB_VBMETA_SYSTEM := system
#BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
#BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
#BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
#BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

#BOARD_AVB_VBMETA_VENDOR := vendor
#BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
#BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA4096
#BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
#BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 3

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 420dpi
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH  := 1080

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=420 \
    vendor.display.lcd_density=420 \

# Fastbootd
PRODUCT_PACKAGES += fastbootd
PRODUCT_PACKAGES += android.hardware.fastboot@1.0-impl-mock

# Fstab
PRODUCT_PACKAGES += \
    fstab.persist \
    fstab.qcom \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.axolotl:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    $(LOCAL_PATH)/rootdir/etc/fstab.persist:$(TARGET_COPY_OUT_RAMDISK)/fstab.persist \

# Init
PRODUCT_PACKAGES += \
    init.qcom.rc \
    init.recovery.qcom.rc \
    ueventd.qcom.rc \
