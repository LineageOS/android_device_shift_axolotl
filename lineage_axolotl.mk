#
# Copyright (C) 2021-2022 SHIFT GmbH
# Copyright (C) 2021-2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from full device.
$(call inherit-product, device/shift/axolotl/full_axolotl.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Override product name for Lineage.
PRODUCT_NAME := lineage_axolotl

# ShiftOS - 3.5 G (20211124)
PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=axolotl \
    PRODUCT_NAME=axolotl \
    PRIVATE_BUILD_DESC="axolotl-user 10 QKQ1.201126.002 20211124 release-keys"

BUILD_FINGERPRINT := SHIFT/axolotl/axolotl:10/QKQ1.201126.002/20211124:user/release-keys
