LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := game_shared

LOCAL_MODULE_FILENAME := libgame

LOCAL_SRC_FILES := hellocpp/main.cpp \
    ../../sources/AppDelegate.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../sources

LOCAL_CFLAGS += -D__GXX_EXPERIMENTAL_CXX0X__ -std=gnu++11 -Wno-psabi -DCC_LUA_ENGINE_ENABLED=1 -DCOCOS2D_DEBUG=0 $(ANDROID_COCOS2D_BUILD_FLAGS)

LOCAL_WHOLE_STATIC_LIBRARIES := quickcocos2dx

include $(BUILD_SHARED_LIBRARY)

# 添加环境变量，这里添加了，ndk编译设置里面就不用添加
QUICK_COCOS2DX_ROOT := $(LOCAL_PATH)/../../..
COCOS2DX_ROOT := $(QUICK_COCOS2DX_ROOT)/lib/cocos2d-x
$(call import-add-path,$(QUICK_COCOS2DX_ROOT))
$(call import-add-path,$(COCOS2DX_ROOT))
$(call import-add-path,$(COCOS2DX_ROOT)/cocos2dx/platform/third_party/android/prebuilt)


$(call import-module,lib/proj.android)
