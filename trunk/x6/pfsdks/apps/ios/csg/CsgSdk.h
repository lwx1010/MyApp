
#import <Foundation/Foundation.h>

@interface CsgSdk : NSObject

+ (void) init:(NSDictionary *)dict;
+ (void) login;
+ (void) pay:(NSDictionary *)dict;

//
+(void)loginCallback;
+(void)exitCallback;
+(void)payCallback;

+ (void) callLua:(NSString *)type retStr:(NSString *)ret;

@end