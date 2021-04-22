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

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Enable updating of APEXes.
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Inherit from axolotl device.
$(call inherit-product, device/shift/axolotl/device.mk)

PRODUCT_NAME := full_axolotl
PRODUCT_DEVICE := axolotl
PRODUCT_BRAND := SHIFT
PRODUCT_MODEL := axolotl
PRODUCT_MANUFACTURER := SHIFT

PRODUCT_GMS_CLIENTID_BASE := android-malata
PRODUCT_SHIPPING_API_LEVEL := 29

PRODUCT_BUILD_PRODUCT_IMAGE  := false
PRODUCT_BUILD_PRODUCT_SERVICES_IMAGE := false

PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true
