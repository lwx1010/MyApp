//
//  PKuaiyongSdk.mm
//  x6
//
//  Created by 02 on 14-2-17.
//  Copyright (c) 2014年 millionhero.com. All rights reserved.
//

#import "CCLuaBridge.h"
#import "CCLuaStack.h"
#import "CCLuaValue.h"
#import "KuaiyongSdk.h"

@implementation KuaiyongSdk

static int s_luaCallBack = 0;

//记录token值
static NSString *gtokenKey = 0;

+(void) init:(NSDictionary *)dict
{
    NSNumber *pCallBack = [dict objectForKey:@"callback"];
    
    s_luaCallBack = [pCallBack intValue];
    
    self = [[KuaiyongSdk alloc] init];
    
    [[KYSDK instance] setKYDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"KY_NOTIFICATION" object:nil];
    
    NSLog(@"初始化 快用");
}

+(void) showLogin
{
    NSLog(@"显示登陆窗口");
    [[KYSDK instance] showUserView];
}

+(void) loginWithLastUser
{
    NSLog(@"快速登录");
    [[KYSDK instance] logWithLastUser];
}

+(void) userBackToLog
{
    NSLog(@"执行返回登陆界面的操作(该方法回先注销用户，该注销没有回调)");
    [[KYSDK instance] userBackToLog];
}

+(void) closeUserSystem
{
    NSLog(@"关闭窗口");
    [[KYSDK instance] closeUserSystem];
}

+(void) logout
{
    NSLog(@"注销");
    [[KYSDK instance] userLogOut];
}

+(void) gameLogMes:(NSDictionary *)dict
{
    NSLog(@"当使用游戏账号登陆后，需要游戏开发商调用该方法，告诉sdk该账号、密码是否正确");
    NSString *mes = [dict objectForKey:@"mes"];
    NSNumber *state = [dict objectForKey:@"state"];
    int nstate = [state intValue];
    
    KYLOGSTATE estate;
    if(nstate == 0)
        estate = KYLOG_SUCCESS;
    else
        estate = KYLOG_ERROR;
    
    [[KYSDK instance] gameLogMes:mes state:estate];
}

+(void) changeLogOption:(NSDictionary *)dict
{
    NSNumber *option = [dict objectForKey:@"option"];
    int noption = [option intValue];
    
    KYLOGOPTION eoption;
    if(noption == 0)
        eoption = KYLOG_ONGAMENAME;
    else
        eoption = KYLOG_OFFGAMENAME;
    
    [[KYSDK instance] changeLogOption:eoption];
}

+ (int) pay:(NSDictionary *)dict
{
    NSLog(@"enter kuaiyong pay");
    NSString *sn = [dict objectForKey:@"sn"];
    NSString *desc = [dict objectForKey:@"desc"];
    NSString *price    = [dict objectForKey:@"price"];
    NSNumber *amount = [dict objectForKey:@"amount"];
    NSString *guid = [dict objectForKey:@"guid"];
    NSString *billTitle = [dict objectForKey:@"billTitle"];
    int needPayRMB = [price intValue];
    
    [[KYSDK instance] showPayWith:sn fee:price game:@"3771" gamesvr:@"" subject:billTitle md5Key:@"yLrPgOxvvVkWhQqczADiXKEEoUDYEXXc" appScheme:@"mhwsdx"];

    return 1;
}

+(NSString*) getSessionId
{
    return gtokenKey;
}

+ (void) callLua:(NSString *)type retStr:(NSString *)ret
{
    if( s_luaCallBack<=0 )
        return;
    
    cocos2d::CCLuaBridge::pushLuaFunctionById(s_luaCallBack);
    
    cocos2d::CCLuaStack *stack = cocos2d::CCLuaBridge::getStack();
    stack->pushString([type UTF8String]);
    stack->pushString([ret UTF8String]);
    stack->executeFunction(2);
}

#pragma mark --KyUserSDKDelegate--
-(void) quickGameWithserviceTokenKey:(NSString *)tokenKey
{
    NSLog(@"快速登陆成功");
    
    gtokenKey = tokenKey;
    [KuaiyongSdk callLua:@"quicklogin" retStr:@"success"];
}

-(void) userLoginWithserviceTokenKey:(NSString *)tokenKey
{
    NSLog(@"用户登陆成功");
    
    gtokenKey = tokenKey;
   [KuaiyongSdk callLua:@"login" retStr:@"success"];
}

-(void) userLoginOut:(NSString *)guid
{
    NSLog(@"用户注销后回调: %@", guid);
    
    [KuaiyongSdk callLua:@"loginout" retStr:guid];
}

// 游戏账户登录成功后回调
-(void) gameLogBack:(NSString *)username passWord:(NSString *)password
{
    NSLog(@"logback: username:%@, passWord:%@", username, password);
    
    [KuaiyongSdk callLua:@"logback" retStr:@"success"];
}

-(void)closeWindow{
    NSLog(@"login window close");
    
    [KuaiyongSdk callLua:@"login" retStr:@"closewindow"];
}

#pragma mark end


#pragma mark --KY_PaySDKDelegate--
//支付宝 '直接' 通知结果
- (void)payResult:(NSNotification*)notification{
    
    id obj = [notification object];
    NSURL * url = obj;
    CHECK result = [[KYSDK instance] checkAlipayResult:url];
    
    [self checkCode:result];
}

-(void)userSelectUnionpay{
    [KuaiyongSdk callLua:@"pay" retStr:@"selectunionpay"];
}

-(void)userDoAlipaywap{
    [KuaiyongSdk callLua:@"pay" retStr:@"selectalipaywap"];
}

-(void)userPayCardSuccess{
    [KuaiyongSdk callLua:@"pay" retStr:@"cardpaysuc"];
}

- (void)userCloseView{
    [KuaiyongSdk callLua:@"pay" retStr:@"closewindow"];
}

-(void)unionpaySuc{
    [KuaiyongSdk callLua:@"pay" retStr:@"unionpaysuc"];
}

-(void)unionpayFail{
    [KuaiyongSdk callLua:@"pay" retStr:@"unionpayfail"];
}

-(void)unionpayCanCel{
    [KuaiyongSdk callLua:@"pay" retStr:@"unionpaycancel"];
}


-(void)userBehavior:(BEHAVIOR)kind{
    
    switch (kind) {
        case USER_DOUNIONPAY:
            
            [self userSelectUnionpay];
            break;
        case USER_DOCARDPAY:
            [self userPayCardSuccess];
            break;
        case USER_CLOSEVIEW:
            
            [self userCloseView];
            break;
        case USER_DOALIPAY:
            
            [self userDoAlipaywap];
            break;
        case USER_UNIPAY_SUCCESS:
            [self unionpaySuc];
            break;
        case USER_UNIPAY_FAIL:
            [self unionpayFail];
            break;
        case USER_UNIPAY_CANCEL:
            [self unionpayCanCel];
            break;

        default:
            break;
    }
    
}


//状态码对应
- (void)checkCode:(CHECK)result{
    
    if(SERVICE_CHECK == result){
        [KuaiyongSdk callLua:@"pay" retStr:@"alipaywaitforresult"];
    }
    
    else if(PAY_SUCCESS == result){
        [KuaiyongSdk callLua:@"pay" retStr:@"alipaysuc"];
    }
    
    else if (PAY_FAILE == result){
        [KuaiyongSdk callLua:@"pay" retStr:@"alipayfail"];
    }
    
    else if(PAY_ERROR == result){
        [KuaiyongSdk callLua:@"pay" retStr:@"alipayerror"];
    }
    
}
#pragma mark end
@end