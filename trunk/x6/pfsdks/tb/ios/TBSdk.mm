
#import "TBSdk.h"
#import "CCLuaBridge.h"
#import "CCLuaStack.h"
#import "CCLuaValue.h"


/* PayDelegate implementaion*/
@implementation PayDelegate

- (void)TBBuyGoodsDidSuccessWithOrder:(NSString*)order{
    NSLog(@"购买成功");
    [TBSdk callLua:@"pay" retStr:@"success"];
}

- (void)TBBuyGoodsDidFailedWithOrder:(NSString *)order resultCode:(TB_BUYGOODS_ERROR)errorType;{
    NSString* err;
    NSString* errType;
    switch (errorType) {
        case kBuyGoodsOrderEmpty:
            err = @"订单号为空";
            errType = @"err0";
            break;
        case kBuyGoodsBalanceNotEnough:
            err = @"推币余额不足";
            errType = @"err1";
            break;
        case kBuyGoodsServerError:
            err = @"服务器错误";
            errType = @"err2";
            break;
        case kBuyGoodsOtherError:
            err = @"其他错误";
            errType = @"err3";
            break;
        default:
            err = @"默认错误";
            errType = @"err4";
            break;
    }
    NSLog(@"pay: %@", err);
    [TBSdk callLua:@"pay" retStr:errType];
}

- (void)TBBuyGoodsDidStartRechargeWithOrder:(NSString *)order{
    NSLog(@"余额不足，进入充值界面");
    [TBSdk callLua:@"pay" retStr:@"enterPayView"];
}

- (void)TBBuyGoodsDidCancelByUser:(NSString *)order{
    NSLog(@"取消支付");
    [TBSdk callLua:@"pay" retStr:@"cancelPay"];
}

- (void)TBCheckOrderSuccessWithResult:(NSDictionary *)dict{
    NSLog(@"Check Result:%@",dict);
    
    NSNumber* state = [dict objectForKey:@"status"];
    int nstate = [state intValue];
    NSString *str = [NSString stringWithFormat:@"%i", nstate];
    
    [TBSdk callLua:@"checksuccess" retStr:str];
}
- (void)TBCheckOrderDidFailed:(NSString *)order{
    /*检查订单失败*/
    NSLog(@"Check Failed:%@",order);
    [TBSdk callLua:@"checkfail" retStr:order];
}

@end


/* TBSdk implementaion*/
@implementation TBSdk

static int s_luaCallback = 0;

+ (void) init:(NSDictionary *)dict
{
    NSNumber *callback    = [dict objectForKey:@"callback"];
    
    s_luaCallback = [callback intValue];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLoginResult:) name:(NSString *)kTBLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSleavePlatform:) name:(NSString *)kTBLeavePlatformNotification object:nil];
}

//登录
+ (void)SNSLoginResult:(NSNotification *)notify
{
	NSDictionary *dict = [notify userInfo];
	BOOL success = [[dict objectForKey:@"result"] boolValue];
    
	//登录成功后处理
	if([[TBPlatform defaultPlatform] isLogined] && success)
    {
        [TBSdk callLua:@"login" retStr:@"success"];
	}
	//登录失败处理和相应提示
	else
    {
		NSString* error = [dict objectForKey:@"error"];
        [TBSdk callLua:@"login" retStr:error];
	}
}

//离开平台
+ (void)SNSleavePlatform:(NSNotification *)notify
{
    NSLog(@"SNSleavePlatform");
    
    NSNumber *type = [notify.userInfo objectForKey:TBLeavedPlatformTypeKey];
    int t = [type intValue];
    
    NSLog(@"%i", t);
    
    NSString* str = [NSString stringWithFormat:@"%i", t];
    
    [TBSdk callLua:@"leaveplatform" retStr:str];
}

+ (int) pay:(NSDictionary *)dict
{
    NSString *sn = [dict objectForKey:@"sn"];
    NSString *desc = [dict objectForKey:@"desc"];
    NSNumber *price    = [dict objectForKey:@"price"];
    NSNumber *amount = [dict objectForKey:@"amount"];
    int needPayRMB = [price intValue];
    PayDelegate* pd = [PayDelegate new];
    
    //发起请求并检查返回值。注意！该返回值并不是交易结果！
    int res = [[TBPlatform defaultPlatform] TBUniPayForCoin:sn needPayRMB:needPayRMB payDescription:desc delegate:pd];
    
    if (res < 0)
    {
        NSLog(@"输入参数有错！无法提交购买请求");
    }
    return res;
}

+ (int) payWithPrice:(NSDictionary *)dict
{
    NSString *sn = [dict objectForKey:@"sn"];
    NSString *desc = [dict objectForKey:@"desc"];
    
    //发起请求并检查返回值。注意！该返回值并不是交易结果！
    int res = [[TBPlatform defaultPlatform] TBUniPayForCoin:sn payDescription:desc];
    
    if (res < 0)
    {
        NSLog(@"输入参数有错！无法提交购买请求");
    }
    return res;
}

+ (int) checkPay:(NSDictionary *)dict
{
    NSString* sn = [dict objectForKey:@"sn"];
    PayDelegate* pd = [PayDelegate new];
    
    
    int res = [[TBPlatform defaultPlatform] TBCheckPaySuccess:sn delegate:pd];
    
    if (res < 0)
    {
        NSLog(@"输入参数有错！无法提交");
    }
    return res;
}

+ (void) showLogin
{
    [[TBPlatform defaultPlatform] TBLogin:0];
}

+ (void) switchAccount
{
    [[TBPlatform defaultPlatform] TBSwitchAccount];
}

+ (void) logout
{
    [[TBPlatform defaultPlatform] TBLogout:0];
}

+ (void) enterUserCenter
{
    [[TBPlatform defaultPlatform] TBEnterUserCenter:0];
}

+ (void) enterAppCenter
{
    [[TBPlatform defaultPlatform] TBEnterAppCenter:0];
}

+ (void) enterBbs
{
    int bbsResult = [[TBPlatform defaultPlatform] TBEnterAppBBS:0];
    
    if (bbsResult == TB_PLATFORM_NO_BBS) {
        NSLog(@"No config BBS");
    }
}


+ (int) isLogined
{
    BOOL ret = [[TBPlatform defaultPlatform] isLogined];
    return ret ? 1 : 0;
}

+ (NSString*) getUin
{
    return [[TBPlatform defaultPlatform] userID];
}


+ (NSString *) getSessionId;
{
    return[[TBPlatform defaultPlatform] sessionId];
}

+ (NSString *) getNickName
{
    return [[TBPlatform defaultPlatform] nickName];
}


+ (void) callLua:(NSString *)type retStr:(NSString *)ret
{
    if( s_luaCallback<=0 )
        return;
    
    cocos2d::CCLuaBridge::pushLuaFunctionById(s_luaCallback);
    
    cocos2d::CCLuaStack *stack = cocos2d::CCLuaBridge::getStack();
    stack->pushString([type UTF8String]);
    stack->pushString([ret UTF8String]);
    stack->executeFunction(2);
}

@end