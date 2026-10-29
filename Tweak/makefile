ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = FreeFire

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = AIMLD
AIMLD_FILES = Tweak.x AuthManager.m ModMenu.swift
AIMLD_CFLAGS = -fobjc-arc
AIMLD_SWIFTFLAGS = -swift-version 5 -import-objc-header Bridging-Header.h -emit-objc-header

include $(THEOS_MAKE_PATH)/tweak.mk