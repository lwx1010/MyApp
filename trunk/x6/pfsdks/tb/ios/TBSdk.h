
#import <Foundation/Foundation.h>
#import "TBPlatform/TBPlatform.h"

@interface TBSdk : NSObject

+ (void) init:(NSDictionary *)dict;

+ (void) SNSLoginResult:(NSNotification *)notify;
+ (void) SNSleavePlatform:(NSNotification *)notify;

+ (int) pay:(NSDictionary *)dict;
+ (int) payWithPrice:(NSDictionary* )dict;
+ (int) checkPay:(NSDictionary*)dict;

+ (void) showLogin;
+ (void) switchAccount;
+ (void) logout;
+ (void) enterUserCenter;
+ (void) enterAppCenter;
+ (void) enterBbs;

+ (int) isLogined;
+ (NSString *) getUin;
+ (NSString *) getSessionId;
+ (NSString *) getNickName;

+ (void) callLua:(NSString *)type retStr:(NSString *)retStrName;

@end

@interface PayDelegate : NSObject<TBBuyGoodsProtocol,TBPayDelegate>

@end