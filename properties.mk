#
# Copyright (C) 2021 SHIFT GmbH
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure the Dalvik heap for a 8GB device
PRODUCT_PROPERTY_OVERRIDES  += \
    dalvik.vm.heapstartsize=16m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.5 \
    dalvik.vm.heapminfree=32m \
    dalvik.vm.heapmaxfree=64m \

# privapp-permissions whitelisting
ifeq ($(TARGET_BUILD_VARIANT),eng)
    PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=log
else
    PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce
endif
