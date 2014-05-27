
#import <Foundation/Foundation.h>

@interface TalkingDataSdk : NSObject

+ (void) start:(NSDictionary *)dict;
+ (void) logEvent:(NSDictionary *)dict;
+ (void) logAccountParams:(NSDictionary *)dict;

+ (void) chargeBegin:(NSDictionary *)dict;
+ (void) chargeEnd:(NSDictionary *)dict;

+ (void) reward:(NSDictionary *)dict;

+ (void) purchase:(NSDictionary *)dict;
+ (void) use:(NSDictionary *)dict;

+ (void) taskBegin:(NSDictionary *)dict;
+ (void) taskComplete:(NSDictionary *)dict;
+ (void) taskFail:(NSDictionary *)dict;

@end