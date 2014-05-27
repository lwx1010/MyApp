
#import "P91Sdk.h"
#import <NdComPlatform/NdComPlatform.h>
#import <NdComPlatform/NdComPlatformAPIResponse.h>
#import <NdComPlatform/NdCPNotifications.h>
#import <NdComPlatform/NdComPlatformError.h>
#import "CCLuaBridge.h"
#import "CCLuaStack.h"
#import "CCLuaValue.h"

@implementation P91Sdk

static int s_luaCallback = 0;

+ (void) init:(NSDictionary *)dict
{
    NSNumber *callback    = [dict objectForKey:@"callback"];
    
    s_luaCallback = [callback intValue];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLoginResult:) name:(NSString *)kNdCPLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSSessionInvalid:) name:(NSString *)kNdCPSessionInvalidNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSleavePlatform:) name:(NSString *)kNdCPLeavePlatformNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSPauseExist:) name:(NSString *)kNdCPPauseDidExitNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NdUniPayAysnResult:) name:kNdCPBuyResultNotification object:nil];
}

//登录
+ (void)SNSLoginResult:(NSNotification *)notify
{
	NSDictionary *dict = [notify userInfo];
	BOOL success = [[dict objectForKey:@"result"] boolValue];
    
	//登录成功后处理
	if([[NdComPlatform defaultPlatform] isLogined] && success)
    {
        [P91Sdk callLua:@"login" retStr:@"success"];
	}
	//登录失败处理和相应提示
	else
    {
		NSString* error = [dict objectForKey:@"error"];
        [P91Sdk callLua:@"login" retStr:error];
	}
}

//会话失效
+ (void)SNSSessionInvalid:(NSNotification *)notify
{
    NSLog(@"SNSSessionInvalid");
    [P91Sdk callLua:@"session" retStr:@"invalid"];
}

//离开平台
+ (void)SNSleavePlatform:(NSNotification *)notify
{
    NSLog(@"SNSleavePlatform");
    [P91Sdk callLua:@"leave" retStr:@"platform"];
}

+ (void)SNSPauseExist:(NSNotification *)notify
{
    NSLog(@"游戏暂停页已关闭，可以继续游戏了");
    [P91Sdk callLua:@"pause" retStr:@"exist"];
}

+ (void)NdUniPayAysnResult:(NSNotification *)notify
{
    NSLog(@"异步支付回调");

    NSDictionary* dic = [notify userInfo];
    BOOL bSuccess = [[dic objectForKey:@"result"] boolValue];
    if (bSuccess)
    {
        [P91Sdk callLua:@"pay" retStr:@"success"];
    }
    else
    {
        NSString* error = [dic objectForKey:@"error"];
        [P91Sdk callLua:@"pay" retStr:error];
    }
}


+ (void) showToolbar:(NSDictionary *)dict
{
    int pos = [[dict objectForKey:@"pos"] intValue];
    if( pos>0 )
    {
        [[NdComPlatform defaultPlatform] NdShowToolBar:(NdToolBarPlace)pos];
    }
    else
    {
        [[NdComPlatform defaultPlatform] NdHideToolBar];
    }
}

+ (int) pay:(NSDictionary *)dict
{
    NSString *sn = [dict objectForKey:@"sn"];
    NSString *desc = [dict objectForKey:@"desc"];
    NSNumber *price    = [dict objectForKey:@"price"];
    NSString *billTitle = [dict objectForKey:@"billTitle"];
    NSNumber *amount = [dict objectForKey:@"amount"];

    NdBuyInfo *buyInfo = [[NdBuyInfo new] autorelease];
    //订单号必须唯一，推荐为GUID或UUID
    buyInfo.cooOrderSerial = sn;
    buyInfo.productId = billTitle; //自定义的产品ID
    buyInfo.productName = billTitle; //产品名称
    buyInfo.productPrice = [price floatValue]; //产品现价，价格大等于0.01,支付价格以此为准
    buyInfo.productOrignalPrice = [price floatValue]; //产品原价，价格同现价保持一致
    buyInfo.productCount = [amount intValue]; //产品数量
    buyInfo.payDescription = desc; //服务器分区，不超过20个字符，只允许英文或数字
    //发起请求并检查返回值。注意！该返回值并不是交易结果！
    int res = [[NdComPlatform defaultPlatform] NdUniPayAsyn: buyInfo];
    if (res < 0)
    {
        NSLog(@"输入参数有错！无法提交购买请求");
    }
    return res;
}

+ (void) showLogin
{
    [[NdComPlatform defaultPlatform] NdLogin:0];
}

+ (void) switchAccount
{
    [[NdComPlatform defaultPlatform] NdSwitchAccount];
}

+ (void) enterAccountManage
{
    [[NdComPlatform defaultPlatform] NdEnterAccountManage];
}

+ (void) logout
{
    [[NdComPlatform defaultPlatform] NdLogout:1];
}

+ (void) feedback
{
    [[NdComPlatform defaultPlatform] NdUserFeedBack];
}

+ (void) showPause
{
    [[NdComPlatform defaultPlatform] NdPause];
}

+ (void) enterPlatform
{
    [[NdComPlatform defaultPlatform] NdEnterPlatform:0];
}

+ (void) enterFriendCenter
{
    [[NdComPlatform defaultPlatform] NdEnterFriendCenter:0];
}

+ (void) enterAppCenter
{
    [[NdComPlatform defaultPlatform] NdEnterAppCenter:0];
}

+ (void) enterMainPage
{
    int appId = [[NdComPlatform defaultPlatform] appId];
    [[NdComPlatform defaultPlatform] NdEnterAppCenter:0 appId:appId];
}

+ (void) enterSetting
{
    [[NdComPlatform defaultPlatform] NdEnterUserSetting:0];
}

+ (void) inviteFriend:(NSDictionary *)dict
{
    NSString *msg = [dict objectForKey:@"msg"];
    [[NdComPlatform defaultPlatform] NdInviteFriend:msg];
}

+ (void) enterBbs
{
    [[NdComPlatform defaultPlatform] NdEnterAppBBS:0];
}


+ (int) isLogined
{
    BOOL ret = [[NdComPlatform defaultPlatform] isLogined];
    return ret ? 1 : 0;
}

+ (NSString*) getUin
{
    return [[NdComPlatform defaultPlatform] loginUin];
}


+ (NSString *) getSessionId;
{
    return [[NdComPlatform defaultPlatform] sessionId];
}

+ (NSString *) getNickName
{
    return [[NdComPlatform defaultPlatform] nickName];
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