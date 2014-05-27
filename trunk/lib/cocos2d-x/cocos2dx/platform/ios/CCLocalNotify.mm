
#import "CCLocalNotify.h"
#import "CCLuaBridge.h"
#import "CCLuaStack.h"
#import "CCLuaValue.h"

NS_CC_BEGIN

UILocalNotification* CCLocalNotify::m_pStartupNotify = 0;
int CCLocalNotify::m_luaCallback = 0;

void CCLocalNotify::setStartupNotify(UILocalNotification * n)
{
	if( !n )
		return;
	
	m_pStartupNotify = [n retain];
}

NSDictionary * CCLocalNotify::getStartupNotify()
{
	if( !m_pStartupNotify )
		return NULL;
		
	return m_pStartupNotify.userInfo;
}

void CCLocalNotify::registerLuaCallback(NSDictionary* params)
{
	if( m_luaCallback!=0 )
	{
		CCLuaBridge::releaseLuaFunctionById(m_luaCallback);
	}
	
	m_luaCallback = [[params objectForKey:@"callback"] intValue];
	
	if( m_luaCallback!=0 )
	{
		CCLuaBridge::retainLuaFunctionById(m_luaCallback);
	}
}

void CCLocalNotify::pushNotifyToLua(UILocalNotification * n)
{
	if( m_luaCallback==0 || !n )
		return;
		
	CCLuaValueDict dict;
	NSDictionary* value = n.userInfo;
    for (id subKey in [value allKeys]) {
        id subValue = [value objectForKey:subKey];
        dict[[subKey UTF8String]] = CCLuaValue::stringValue([subValue UTF8String]);
    }
	
	CCLuaBridge::getStack()->pushCCLuaValueDict(dict);
	CCLuaBridge::getStack()->executeFunctionByHandler(m_luaCallback, 1);
}

void CCLocalNotify::pushNotifyToIos(NSDictionary* params)
{
    //------通知；  
    UILocalNotification *notification=[[UILocalNotification alloc] init];   
    if (notification!=nil) {//判断系统是否支持本地通知  
		NSString *body = [params objectForKey:@"body"];
		NSString *action = [params objectForKey:@"action"];
		int delay = [[params objectForKey:@"delay"] intValue];
	
        NSDate *now = [NSDate new];
        //        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:kCFCalendarUnitDay];//本次开启立即执行的周期  
        notification.fireDate = [now dateByAddingTimeInterval:delay];//本次开启立即执行的周期  
        //notification.repeatInterval = kCFCalendarUnitMinute;//循环通知的周期  
        notification.timeZone = [NSTimeZone defaultTimeZone];  
        notification.alertBody = body;//弹出的提示信息  
		notification.alertAction = action;  //弹出的提示框按钮  
        notification.applicationIconBadgeNumber=1; //应用程序的右上角小数字  
        notification.soundName = UILocalNotificationDefaultSoundName;//本地化通知的声音  
		notification.userInfo = [NSDictionary dictionaryWithDictionary:params];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
		
		[notification release];
    }   
}

void CCLocalNotify::cancelNotify(NSDictionary* params)
{
	NSString *key = [params objectForKey:@"key"];
	if( !key )
		return;
	
	UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    UILocalNotification *localNoti = nil;
    
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key"];
                if ([inKey isEqualToString:key]) {
                    if (localNoti){
                        [localNoti release];
                        localNoti = nil;
                    }
                    localNoti = [noti retain];
                    break;
                }
            }
        }
        
        if (localNoti ) {
            //不推送 取消推送
            [app cancelLocalNotification:localNoti];
            [localNoti release];
            return;
        }
	}
}

void CCLocalNotify::cancelAllNotify()
{
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
}

NS_CC_END
