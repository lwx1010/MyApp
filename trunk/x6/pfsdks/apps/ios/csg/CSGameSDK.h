//
//  CSGameSDK.h
//  CSGameSDK
//
//  Created by Zeng YunSong on 14-3-14.
//  Copyright (c) 2014年 Zeng YunSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSGameSDK : NSObject
#pragma mark - 常量定义



//用户登陆，在用户登陆或者用户完成注册后进行通知
#define CSG_SDK_MSG_LOGIN_FIN           @"csg_sdk_msg_login_fin"

//SDK 未登录退出，在SDK退出后进行通知
#define CSG_SDK_MSG_EXIT_WITHOUT_LOGIN  @"csg_sdk_msg_exit_without_login"

//SDK 支付界面退出，在游戏调用SDK支付界面，退出支付界面后进行通知
#define CSG_SDK_MSG_PAY_EXIT            @"csg_sdk_msg_pay_exit"







//游戏拼音
#define CSG_SDK_KEY_PAY_GAME                   @"game"
// 服务器序号
#define CSG_SDK_KEY_PAY_SERVER                 @"server"
//用户名
#define CSG_SDK_KEY_PAY_USERNAME               @"username"
//应用渠道
#define CSG_SDK_KEY_PAY_REFERER                @"referer"
// 定额支付金额，单位为元，最小单位为1元
#define CSG_SDK_KEY_PAY_AMOUNT                  @"amount"
//客户端标示符号
#define CSG_SDK_KEY_PAY_UNI                  @"uni"



/**
 @brief 获取UCGameSdk的实例对象
 */
+ (CSGameSDK *)defaultSDK;


/**
 *@brief 如果此标识不为空，则代表已有用户登录
 */
- (NSString *)username;


#pragma mark - UI

/**
 *@brief 进入登录界面
 */
- (void)login;

/**
 *@brief 进入支付界面
 */
- (void)pay:(NSMutableDictionary *)dict;



@end
