# Архитектура
ARCHS = arm64

# Опции сборки
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
IGNORE_WARNINGS = 1

# Цель сборки
TARGET = iphone:clang:latest
SDKVERSION =

# Пути Theos
THEOS ?= /var/theos
THEOS_MAKE_PATH ?= $(THEOS)/makefiles
include $(THEOS)/makefiles/common.mk

# Имя tweak
TWEAK_NAME = FF

# Исходники
SECURITY_SRC = $(wildcard Security/*.mm) $(wildcard Security/oxorany/*.cpp)
LOADVIEW_SRC = $(wildcard LoadView/*.mm) $(wildcard LoadView/*.m)
IMGUI_SRC = $(wildcard imgui/*.cpp) $(wildcard imgui/*.mm)

FF_FILES = \
    ImGuiDrawView.mm \
    $(SECURITY_SRC) \
    $(LOADVIEW_SRC) \
    $(IMGUI_SRC) \
    $(wildcard hook/*.c) \
    $(wildcard Hosts/*.m)

# Фреймворки
FF_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText AVFoundation Accelerate GLKit SystemConfiguration GameController Metal MetalKit

# Флаги компилятора
FF_CCFLAGS = -std=c++17 -stdlib=libc++ -fno-rtti -fno-exceptions -DNDEBUG \
             -Wall -Wno-deprecated-declarations -Wno-unused-variable \
             -Wno-unused-value -Wno-unused-function -fvisibility=hidden

FF_CFLAGS = -fobjc-arc -Wall -Wno-deprecated-declarations \
            -Wno-unused-variable -Wno-unused-value -Wno-unused-function \
            -fvisibility=hidden

ifeq ($(IGNORE_WARNINGS),1)
  FF_CFLAGS += -w
  FF_CCFLAGS += -w
endif

# Подключаем Makefile для tweak
include $(THEOS_MAKE_PATH)/tweak.mk