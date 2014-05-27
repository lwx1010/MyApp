
#import <Foundation/Foundation.h>

@interface SDKUmeng : NSObject

+ (void) start:(NSDictionary *)dict;
+ (void) updateOnlineConfig;
+ (void) setSendInterval:(NSDictionary *)dict;
+ (void) logEvent:(NSDictionary *)dict;
+ (void) beginEvent:(NSDictionary *)dict;
+ (void) endEvent:(NSDictionary *)dict;
+ (void) setViewController:(UIViewController *)controller;
+ (void) shareEvent:(NSDictionary *)dict;



@end