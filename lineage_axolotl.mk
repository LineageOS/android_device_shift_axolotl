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
