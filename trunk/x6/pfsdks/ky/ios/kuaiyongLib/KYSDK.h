//
//  KYSDK.h
//  KYSDK
//
//  Created by KY_ljf on 14-1-6.
//  Copyright (c) 2014年 KY_ljf. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户代理回调
@protocol KyUserSDKDelegate <NSObject>

/**
 登录成功回调
 **/
-(void)userLoginWithserviceTokenKey:(NSString *)tokenKey;

/**
 快速登录成功回调
 **/
-(void)quickGameWithserviceTokenKey:(NSString *)tokenKey;

/**
 游戏账号登录回调
 **/
-(void)gameLogBack:(NSString *)username passWord:(NSString *)password;

/**
 注销成功回调
 **/
-(void)userLoginOut:(NSString *)guid;

-(void)returnKeyDidClick;

@end


//以下为支付代理回调
enum{
    SERVICE_CHECK = -1,     //等待服务器验证
    PAY_SUCCESS = 0,        //结果正确
    PAY_FAILE = 1,          //结果错误
    PAY_ERROR = 2          //验证失败
}typedef CHECK;

enum{
    USER_DOUNIONPAY = 0,    //用户进行银联支付
    USER_DOCARDPAY = 1,     //用户提交了卡类订单
    USER_CLOSEVIEW = 2,     //用户关闭了支付界面
    USER_DOALIPAY = 3,      //用户使用了支付宝wap
    USER_UNIPAY_SUCCESS = 4,  //用户银联支付成功
    USER_UNIPAY_FAIL = 5,    //用户银联支付失败
    USER_UNIPAY_CANCEL = 6    //用户取消银联支付
}typedef BEHAVIOR;

enum{
    KYLOG_SUCCESS,//游戏账户登录成功
    KYLOG_ERROR//游戏账户登录失败
}typedef KYLOGSTATE;

enum{
    KYLOG_ONGAMENAME,//显示游戏账号登录
    KYLOG_OFFGAMENAME//不显示游戏账号登录
}typedef KYLOGOPTION;

@protocol KY_PaySDKDelegate <NSObject>

//用户行为
-(void)userBehavior:(BEHAVIOR)kind;

//查看订单返回结果
/**
 result: code为0时，成功 其他失败
 deal：订单信息 orderid：sdk内部订单信息 dealSeq：游戏订单信息 dealSeq
 payresult = 0支付成功，1支付失败
 **/
-(void)backCheckDel:(NSMutableDictionary *)map;

@end

@interface KYSDK : NSObject

/**
 初始化实例
 **/
+(KYSDK *)instance;

/**
 设置代理
 **/
-(void)setKYDelegate:(id<KyUserSDKDelegate,KY_PaySDKDelegate>)kySdkDelegate;

/**
 显示用户
 **/
-(void)showUserView;

/**
 关闭用户界面
 **/
-(void)closeUserSystem;

/**
 主动注销用户
 **/
-(void)userLogOut;

/**
 直接返回登录界面
 **/
-(void)userBackToLog;

/**
 用上次登录的账号密码直接登录
 **/
-(void)logWithLastUser;

/**
 游戏账号登录时，回调后调用，用于给sdk传入登录是否成功的信息
 **/
-(void)gameLogMes:(NSString *)mes state:(KYLOGSTATE)state;

/**
 控制登陆界面是否含有游戏账号的选项（新游戏没有老用户时，可将游戏账号关掉）
 **/
-(void)changeLogOption:(KYLOGOPTION)option;

//支付相关方法
/**
 显示支付
 dealseq：订单号
 fee：金额
 game：http://payquery.bppstore.com上面对应ID
 gamesvr：多个通告地址的选择设置，
 md5Key：http://payquery.bppstore.com该网址对应的密匙
 appScheme：支付宝快捷支付对应的回调应用名称，要与targets-》info-》url types中的 url schemes中设置的对应
 **/
-(void)showPayWith:(NSString *)dealseq fee:(NSString *)fee game:(NSString *)game gamesvr:(NSString *)gamesvr subject:(NSString *)subject md5Key:(NSString *)md5Key appScheme:(NSString *)urlScheme;
/**
 检查支付宝快捷支付回调url
 **/
-(CHECK)checkAlipayResult:(NSURL *)url;

/**
 查看订单信息（单机游戏）
 **/
-(void)checkDealseq:(NSString *)dealseq game:(NSString *)game md5Key:(NSString *)md5Key;
@end
