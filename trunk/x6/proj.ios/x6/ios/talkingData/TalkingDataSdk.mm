
#import "TalkingDataSdk.h"
#import "TalkingDataGA.h"

@implementation TalkingDataSdk

static TDGAAccount *s_account = nil;
static NSString *s_accountId = nil;

+ (void) start:(NSDictionary *)dict
{
    NSString *appKey    = [dict objectForKey:@"appKey"];
    NSString *channelId = [dict objectForKey:@"channel"];
    
    [TalkingDataGA onStart:appKey withChannelId:channelId];
}

+ (void) logEvent:(NSDictionary *)dict
{
    NSUInteger count = [dict count];
    NSString *event = [dict objectForKey:@"event"];
    assert(count > 0 && event);
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    for (NSString *key in dict)
    {
        if ([key compare:@"event"] == NSOrderedSame) continue;
        id val = [dict objectForKey:key];
        if ([val isKindOfClass:[NSNumber class]])
        {
            [attributes setObject:[val stringValue] forKey:key];
        }
        else
        {
            [attributes setObject:val forKey:key];
        }
    }
    [TalkingDataGA onEvent:event eventData:attributes];
}

+ (void) logAccountParams:(NSDictionary *)dict
{
    NSString *accountId = [dict objectForKey:@"account"];
    if( accountId!=nil && (s_accountId==nil || [accountId compare:s_accountId]!=NSOrderedSame) )
    {
        s_account = [TDGAAccount setAccount:accountId];
        
        if( s_accountId!=nil )
        {
            [s_accountId release];
        }
        
        s_accountId = accountId;
        [s_accountId retain];
    }
    
    if( s_account==nil )
        return;
    
    for (NSString *key in dict)
    {
        id val = [dict objectForKey:key];
        if ([key compare:@"level"] == NSOrderedSame)
        {
            [s_account setLevel:[val intValue]];
            continue;
        }
        
        if ([key compare:@"server"] == NSOrderedSame)
        {
            [s_account setGameServer:[val stringValue]];
            continue;
        }
        
        if ([key compare:@"name"] == NSOrderedSame)
        {
            [s_account setAccountName:val];
            continue;
        }
        
        if ([key compare:@"type"] == NSOrderedSame)
        {
            TDGAAccountType type = (TDGAAccountType)[val intValue];
            [s_account setAccountType:type];
            continue;
        }
        
        if ([key compare:@"gender"] == NSOrderedSame)
        {
            int gender = [val intValue];
            if( gender==0 )
            {
                [s_account setGender:kGenderMale];
            }
            else if( gender==1 )
            {
                [s_account setGender:kGenderFemale];
            }
            else
            {
                [s_account setGender:kGenderUnknown];
            }
            continue;
        }
        
        if ([key compare:@"age"] == NSOrderedSame)
        {
            [s_account setAge:[val intValue]];
            continue;
        }
    }
}

+ (void) chargeBegin:(NSDictionary *)dict
{
    NSString *orderId = [dict objectForKey:@"orderId"];
    NSString *iapId = [dict objectForKey:@"iapId"];
    double amount = [[dict objectForKey:@"amount"] intValue];
    NSString *type = [dict objectForKey:@"type"];
    double visualAmount = [[dict objectForKey:@"visualAmount"] intValue];
    NSString *payType = [dict objectForKey:@"payType"];
    
    [TDGAVirtualCurrency onChargeRequst:orderId iapId:iapId currencyAmount:amount currencyType:type virtualCurrencyAmount:visualAmount paymentType:payType];
}

+ (void) chargeEnd:(NSDictionary *)dict
{
    NSString *orderId = [dict objectForKey:@"orderId"];
    
    [TDGAVirtualCurrency onChargeSuccess:orderId];
}

+ (void) reward:(NSDictionary *)dict
{
    double amount = [[dict objectForKey:@"amount"] intValue];
    NSString *reason = [dict objectForKey:@"reason"];
    
    [TDGAVirtualCurrency onReward:amount reason:reason];
}

+ (void) purchase:(NSDictionary *)dict
{
    NSString *item = [dict objectForKey:@"item"];
    int count = [[dict objectForKey:@"count"] intValue];
    double price = [[dict objectForKey:@"price"] intValue];
    
    [TDGAItem onPurchase:item itemNumber:count priceInVirtualCurrency:price];
}

+ (void) use:(NSDictionary *)dict
{
    NSString *item = [dict objectForKey:@"item"];
    int count = [[dict objectForKey:@"count"] intValue];
    
    [TDGAItem onUse:item itemNumber:count];
}

+ (void) taskBegin:(NSDictionary *)dict
{
    NSString *taskId = [dict objectForKey:@"id"];
    
    [TDGAMission onBegin:taskId];
}

+ (void) taskComplete:(NSDictionary *)dict
{
    NSString *taskId = [dict objectForKey:@"id"];
    
    [TDGAMission onCompleted:taskId];
}

+ (void) taskFail:(NSDictionary *)dict
{
    NSString *taskId = [dict objectForKey:@"id"];
    NSString *reason = [dict objectForKey:@"reason"];
    
    [TDGAMission onFailed:taskId failedCause:reason];
}

@end