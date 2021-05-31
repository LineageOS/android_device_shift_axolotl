#
# Copyright (C) 2021 SHIFT GmbH
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Use the non-open-source parts, if they're present
-include vendor/shift/axolotl/BoardConfigVendor.mk

DEVICE_PATH := device/shift/axolotl

# We ship prebuilt files, which override source built components, eg "audio.primary.sdm845.so"
BUILD_BROKEN_DUP_RULES := true

# We copy prebuilt binaries and libs instead of packaging them
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Our properties are not fully compliant with Android S+ yet
BUILD_BROKEN_ENFORCE_SYSPROP_OWNER := true
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true

#####

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo385

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := sdm845
TARGET_NO_BOOTLOADER := true

# Display
TARGET_SCREEN_DENSITY := 420

# Kernel
TARGET_NO_KERNEL := false
TARGET_NO_KERNEL_OVERRIDE := false

ifeq ($(TARGET_BUILD_VARIANT),eng)
    TARGET_KERNEL_CONFIG := lineage_axolotl_eng_defconfig
else
    TARGET_KERNEL_CONFIG := lineage_axolotl_defconfig
endif
TARGET_KERNEL_SOURCE := kernel/shift/sdm845

BOARD_KERNEL_IMAGE_NAME  := Image.gz-dtb
BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096

BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom
# Enable console for eng builds
ifeq ($(TARGET_BUILD_VARIANT),eng)
    BOARD_KERNEL_CMDLINE += console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0xA84000
endif
BOARD_KERNEL_CMDLINE += androidboot.console=ttyMSM0 printk.devkmsg=on
BOARD_KERNEL_CMDLINE += video=vfb:640x400,bpp=32,memsize=3072000 androidboot.configfs=true loop.max_part=7
BOARD_KERNEL_CMDLINE += msm_rtb.filter=0x237
BOARD_KERNEL_CMDLINE += ehci-hcd.park=3
BOARD_KERNEL_CMDLINE += service_locator.enable=1
BOARD_KERNEL_CMDLINE += androidboot.memcg=1 cgroup.memory=nokmem
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=a600000.dwc3 swiotlb=2048
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/1d84000.ufshc

# (BOARD_KERNEL_PAGESIZE * 32)
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_BOOT_HEADER_VERSION := 2
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# Platform
TARGET_BOARD_PLATFORM := sdm845

#####

# AB
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    recovery \

AB_OTA_PARTITIONS += \
    product \
    system \
    system_ext \
    vendor \

AB_OTA_PARTITIONS += \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \

# AVB
BOARD_AVB_VBMETA_SYSTEM := system system_ext
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 3

# Enable AVB 2.0
BOARD_AVB_ENABLE := true

# Build the image with verity pre-disabled - https://android.googlesource.com/platform/external/avb/+/58305521295e51cb52a74d8d8bbaed738cf0767a
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

#####

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "qualcomm-hidl"

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Audio
#AUDIO_FEATURE_ENABLED_AAC_ADTS_OFFLOAD := true
#AUDIO_FEATURE_ENABLED_AHAL_EXT := true
AUDIO_FEATURE_ENABLED_AUDIOSPHERE := true
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true
TARGET_PROVIDES_AUDIO_EXTNS := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/rootdir/config.fs

# Graphics
TARGET_USES_GRALLOC1 := true
TARGET_USES_HWC2 := true
TARGET_USES_ION := true

# HIDL
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/vintf/compatibility_matrix.xml

# Light
TARGET_PROVIDES_LIBLIGHT := true

# LMKD
TARGET_LMKD_STATS_LOG := true

# Power
TARGET_TAP_TO_WAKE_NODE := "/proc/touchpanel/double_tap_enable"

# Qualcomm BSP
BOARD_USES_QCOM_HARDWARE := true

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.axolotl
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_UI_LIB := libfstab

# RenderScript
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2022-08-05

# SELinux
include device/qcom/sepolicy_vndr-legacy-um/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Treble
BOARD_VNDK_VERSION := current
BOARD_SYSTEMSDK_VERSIONS := 29

# WLAN
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_DEFAULT := wlan
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

##### Partition handling

BOARD_DYNAMIC_PARTITION_ENABLE := true

# Define the Dynamic Partition sizes and groups.
BOARD_SUPER_PARTITION_SIZE := 12884901888
BOARD_SUPER_PARTITION_GROUPS := axolotl_dynamic_partitions
BOARD_AXOLOTL_DYNAMIC_PARTITIONS_SIZE := 6438256640
BOARD_AXOLOTL_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    product \
    system \
    system_ext \
    vendor \

# Set error limit to BOARD_SUPER_PARTITON_SIZE - 500MB
BOARD_SUPER_PARTITION_ERROR_LIMIT := 12360613888

# boot.img
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x04000000

# dtbo.img
BOARD_DTBOIMG_PARTITION_SIZE := 0x0800000

# metadata.img
BOARD_METADATAIMAGE_PARTITION_SIZE := 16777216
BOARD_USES_METADATA_PARTITION := true

# persist.img
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4

# product.img
BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_PRODUCT := product

# recovery.img
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x06000000

# system.img
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4

# system_ext.img
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext

# userdata.img
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# vendor.img
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# vendor.img - split
TARGET_COPY_OUT_VENDOR := vendor

# Reserve space for gapps installation and other customizations
# product:    1500 MB
# system:      500 MB
# system_ext:  500 MB
# vendor:      250 MB
ifneq ($(WITH_GMS),true)
    BOARD_PRODUCTIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 1572864000
    BOARD_SYSTEM_EXTIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE := 524288000
    BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 524288000
    BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 262144000
endif

# Include ShiftOS specific BoardConfig if existing
-include device/shift/axolotl/shiftos/BoardConfig.mk
