
#import "CsgSdk.h"
#import "CSGameSDK.h"
#import "CCLuaBridge.h"
#import "CCLuaStack.h"
#import "CCLuaValue.h"

@implementation CsgSdk

static int s_luaCallback = 0;

+ (void) init:(NSDictionary *)dict
{
    NSNumber *callback    = [dict objectForKey:@"callback"];
    
    s_luaCallback = [callback intValue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCallback) name:CSG_SDK_MSG_LOGIN_FIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitCallback) name:CSG_SDK_MSG_EXIT_WITHOUT_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCallback) name:CSG_SDK_MSG_PAY_EXIT object:nil];
}

+(void)login
{
    [[CSGameSDK defaultSDK] login];
}

+ (void) pay:(NSDictionary *)dict
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setObject:[dict objectForKey:@"game"] forKey:CSG_SDK_KEY_PAY_GAME];
    [paramDict setObject:[dict objectForKey:@"server"] forKey:CSG_SDK_KEY_PAY_SERVER];
    [paramDict setObject:[dict objectForKey:@"userName"] forKey:CSG_SDK_KEY_PAY_USERNAME];
    [paramDict setObject:[dict objectForKey:@"peferer"] forKey:CSG_SDK_KEY_PAY_REFERER];
    [paramDict setObject:[dict objectForKey:@"amount"] forKey:CSG_SDK_KEY_PAY_AMOUNT];
    [paramDict setObject:[dict objectForKey:@"uni"] forKey:CSG_SDK_KEY_PAY_UNI];
    [[CSGameSDK defaultSDK] pay:paramDict];
}


+(void)loginCallback
{
    NSString* userName = [[CSGameSDK defaultSDK] username];
    NSLog(@"loing with:%@",userName);
    
    [CsgSdk callLua:@"login" retStr:userName];
}

+(void)exitCallback
{
    NSLog(@"退出登录");
    
    [CsgSdk callLua:@"exit" retStr:@""];
}

+(void)payCallback
{
    NSLog(@"退出充值");
    
    [CsgSdk callLua:@"pay" retStr:@""];
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