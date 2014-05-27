
#ifndef __CC_LOCAL_NOTIFY_H__
#define __CC_LOCAL_NOTIFY_H__

#include "platform/CCCommon.h"

NS_CC_BEGIN

class CC_DLL CCLocalNotify
{
public:
	// 设置启动的通知
	static void setStartupNotify(UILocalNotification * n);
	// 获取启动的通知
	static NSDictionary * getStartupNotify();
	
	// 注册Lua的回调函数
	static void registerLuaCallback(NSDictionary* params);
	// 推送通知到Lua
	static void pushNotifyToLua(UILocalNotification * n);
	
	// 推送通知到系统
	static void pushNotifyToIos(NSDictionary* params);
	
	// 取消通知
	static void cancelNotify(NSDictionary* params);
	// 取消所有通知
	static void cancelAllNotify();

protected:
    static UILocalNotification * m_pStartupNotify;
	static int m_luaCallback;
};

NS_CC_END

#endif    // end of __CC_LOCAL_NOTIFY_H__
