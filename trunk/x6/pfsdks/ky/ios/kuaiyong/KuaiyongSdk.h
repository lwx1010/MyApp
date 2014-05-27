//
//  PKuaiyongSdk.h
//  x6
//
//  Created by 02 on 14-2-17.
//  Copyright (c) 2014年 millionhero.com. All rights reserved.
//

#ifndef x6_PKuaiyongSdk_h
#define x6_PKuaiyongSdk_h

#import <Foundation/Foundation.h>
#import "KYSDK.h"

@interface KuaiyongSdk : UIViewController<KyUserSDKDelegate, KY_PaySDKDelegate>

+ (void) init:(NSDictionary *)dict;

+ (void) showLogin;
+ (void) loginWithLastUser;
+ (void) userBackToLog;
+ (void) closeUserSystem;
+ (void) logout;
+ (void) gameLogMes:(NSDictionary *)dict;
+ (void) changeLogOption:(NSDictionary *)dict;

+ (int) pay:(NSDictionary *)dict;

+ (NSString*) getSessionId;


+ (void) callLua:(NSString *)type retStr:(NSString *)retStrName;

@end

#endif
