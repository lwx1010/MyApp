
#import <Foundation/Foundation.h>

@interface PPSdk : NSObject

+ (void) showLogin;
+ (void) showCenter;
+ (void) exchangeGoods:(NSDictionary *)dict;
+ (void) setOpenPay:(NSDictionary *)dict;

+ (NSString *) currentUserId;
+ (NSString *) currentUserName;

+ (void) setLuaCallback:(NSDictionary *)dict;
+ (void) callLua:(NSString *)type retStr:(NSString *)retStrName;
    
+ (void) setUpdateEnd:(BOOL)end;
+ (BOOL) isUpdateEnd;

@end