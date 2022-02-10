#
# Copyright (C) 2021-2022 SHIFT GmbH
# Copyright (C) 2021-2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from axolotl device.
$(call inherit-product, device/shift/axolotl/device.mk)

PRODUCT_NAME := full_axolotl
PRODUCT_DEVICE := axolotl
PRODUCT_BRAND := SHIFT
PRODUCT_MODEL := axolotl
PRODUCT_MANUFACTURER := SHIFT

PRODUCT_GMS_CLIENTID_BASE := android-malata
PRODUCT_SHIPPING_API_LEVEL := 29

# GMS (EEA - v2 - 4c)
GMS_MAKEFILE := gms_eea_v2_type4c.mk
#MAINLINE_MODULES_MAKEFILE := mainline_modules.mk

# ShiftOS - 3.5 G (20211124)
PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=axolotl \
    PRODUCT_NAME=axolotl \
    PRIVATE_BUILD_DESC="axolotl-user 10 QKQ1.201126.002 20211124 release-keys"

BUILD_FINGERPRINT := SHIFT/axolotl/axolotl:10/QKQ1.201126.002/20211124:user/release-keys
