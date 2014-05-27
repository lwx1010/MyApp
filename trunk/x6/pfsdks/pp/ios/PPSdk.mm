
#import "PPSdk.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#import "CCLuaBridge.h"
#import "CCLuaStack.h"
#import "CCLuaValue.h"

@implementation PPSdk

static int s_ppLuaCallback = 0;
static BOOL s_isUpdate = FALSE;

+ (void) showLogin
{
    [[PPAppPlatformKit sharedInstance] showLogin];
}

+ (void) showCenter
{
    [[PPAppPlatformKit sharedInstance] showCenter];
}

+ (void) exchangeGoods:(NSDictionary *)dict
{
    NSNumber *price    = [dict objectForKey:@"price"];
    NSString *billNo    = [dict objectForKey:@"billNo"];
    NSString *billTitle = [dict objectForKey:@"billTitle"];
    NSString *roleId = [[dict objectForKey:@"roleId"] stringValue];
    NSNumber *zoneId = [dict objectForKey:@"zoneId"];
    
    int zone = zoneId ? [zoneId intValue] : 0;
    [[PPAppPlatformKit sharedInstance] exchangeGoods:[price intValue] BillNo:billNo BillTitle:billTitle RoleId:(roleId ? roleId : @"0") ZoneId:zone];
}

+ (void) setOpenPay:(NSDictionary *)dict
{
    NSNumber *isOpen    = [dict objectForKey:@"isOpen"];
    NSString *closeMsg    = [dict objectForKey:@"closeMsg"];
    
    if( isOpen!=nil )
    {
        BOOL open = [isOpen intValue]>0;
        [[PPAppPlatformKit sharedInstance] setIsOpenRecharge:open];
    }

    if( closeMsg!=nil )
    {
        [[PPAppPlatformKit sharedInstance] setCloseRechargeAlertMessage:closeMsg];
    }
}

+ (NSString *) currentUserId
{
    uint64_t uid = [[PPAppPlatformKit sharedInstance] currentUserId];
	return [[NSString alloc] initWithFormat:@"%qu", uid];
}

+ (NSString *) currentUserName
{
    return [[PPAppPlatformKit sharedInstance] currentUserName];
}

+ (void) setLuaCallback:(NSDictionary *)dict
{
    NSNumber *callback    = [dict objectForKey:@"callback"];
    s_ppLuaCallback = [callback intValue];
}

+ (void) callLua:(NSString *)type retStr:(NSString *)ret
{
    if( s_ppLuaCallback<=0 )
        return;
    
    cocos2d::CCLuaBridge::pushLuaFunctionById(s_ppLuaCallback);
    
    cocos2d::CCLuaStack *stack = cocos2d::CCLuaBridge::getStack();
    stack->pushString([type UTF8String]);
    stack->pushString([ret UTF8String]);
    stack->executeFunction(2);
}
    
+ (void) setUpdateEnd:(BOOL)end
{
    s_isUpdate = end;
}
    
+ (BOOL) isUpdateEnd
{
    return s_isUpdate;
}

@end