APP_STL := gnustl_static
APP_CPPFLAGS := -D__GXX_EXPERIMENTAL_CXX0X__ -std=gnu++11 -frtti -DCOCOS2D_DEBUG=0 -Wno-error=format-security -fsigned-char -Os $(CPPFLAGS)
APP_ABI := armeabi