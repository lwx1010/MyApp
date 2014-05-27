
#import "SDKUmeng.h"
#import "MobClick.h"
//#import "UMSocial.h"

@implementation SDKUmeng

// 存储视图控制器对象
static UIViewController *s_controller = nil;
NSString *s_appKey = nil;

+ (void) setViewController:(UIViewController *)controller
{
    // 设置视图控制器
    s_controller = controller;
    [s_controller retain];
}

+ (void) start:(NSDictionary *)dict
{
    NSString *appKey    = [dict objectForKey:@"appKey"];
    NSNumber *policy    = [dict objectForKey:@"policy"];
    NSString *channelId = [dict objectForKey:@"channel"];
    
    s_appKey = appKey;
    [s_appKey retain];
    
    //[UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    //[UMSocialConfig setSupportSinaSSO:NO];

    [MobClick startWithAppkey:appKey
                 reportPolicy:(ReportPolicy)(policy ? [policy intValue] : BATCH)
                    channelId:channelId];
}

+ (void) updateOnlineConfig
{
    [MobClick updateOnlineConfig];
}

+ (void) setSendInterval:(NSDictionary *)dict
{
    NSNumber *interval    = [dict objectForKey:@"interval"];
    
    [MobClick setLogSendInterval:[interval doubleValue]];
}

+ (void) logEvent:(NSDictionary *)dict
{
    NSUInteger count = [dict count];
    NSString *event = [dict objectForKey:@"event"];
    assert(count > 0 && event);
    
    if (count == 1)
    {
        [MobClick event:event];
    }
    else
    {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        for (NSString *key in dict) {
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
        [MobClick event:event attributes:attributes];
    }
}

+ (void) beginEvent:(NSDictionary *)dict
{
    NSUInteger count = [dict count];
    NSString *event = [dict objectForKey:@"event"];
    assert(count > 0 && event);
    assert(count > 0);
    
    if (count == 1)
    {
        [MobClick beginEvent:event];
    }
    else
    {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        for (NSString *key in dict) {
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
        [MobClick beginEvent:event primarykey:event attributes:attributes];
    }
}

+ (void) endEvent:(NSDictionary *)dict
{
    NSUInteger count = [dict count];
    NSString *event = [dict objectForKey:@"event"];
    assert(count > 0 && event);
    
    [MobClick endEvent:event];
}

// social --------------------------------------

+ (void) shareEvent:(NSDictionary *)dict
{
    // 从 dict 参数中提取需要的数据
    NSString *text   = [dict objectForKey:@"text"];
    
    // 检查参数是否有效
    if (!text) return;
    
    // 调用 SDK 的方法
//    [UMSocialSnsService presentSnsIconSheetView:s_controller
//                                         appKey:s_appKey
//                                      shareText:text
//                                     shareImage:nil
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToTencent, UMShareToRenren, UMShareToQzone,UMShareToDouban, nil]
//                                       delegate:nil];
}


@end