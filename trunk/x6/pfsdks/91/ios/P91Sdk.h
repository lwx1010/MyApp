
#import <Foundation/Foundation.h>

@interface P91Sdk : NSObject

+ (void) init:(NSDictionary *)dict;

+ (void) SNSLoginResult:(NSNotification *)notify;
+ (void) SNSSessionInvalid:(NSNotification *)notify;
+ (void) SNSleavePlatform:(NSNotification *)notify;
+ (void) SNSPauseExist:(NSNotification *)notify;
+ (void) NdUniPayAysnResult:(NSNotification *)notify;

+ (void) showToolbar:(NSDictionary *)dict;
+ (int) pay:(NSDictionary *)dict;

+ (void) showLogin;
+ (void) switchAccount;
+ (void) enterAccountManage;
+ (void) logout;
+ (void) feedback;
+ (void) showPause;
+ (void) enterPlatform;
+ (void) enterFriendCenter;
+ (void) enterAppCenter;
+ (void) enterMainPage;
+ (void) enterSetting;
+ (void) inviteFriend:(NSDictionary *)dict;
+ (void) enterBbs;

+ (int) isLogined;
+ (NSString *) getUin;
+ (NSString *) getSessionId;
+ (NSString *) getNickName;

+ (void) callLua:(NSString *)type retStr:(NSString *)retStrName;

@end