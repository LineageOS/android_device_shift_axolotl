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

# Inherit from AOSP device.
$(call inherit-product, device/shift/axolotl/full_axolotl.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit GSI product for now, until we support "normal" builds.
$(call inherit-product, vendor/lineage/build/target/product/lineage_arm64_ab.mk)

# Override product name for Lineage.
PRODUCT_NAME := lineage_axolotl
