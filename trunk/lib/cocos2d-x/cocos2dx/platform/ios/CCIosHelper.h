#import <Foundation/Foundation.h>

@interface CCIosHelper : NSObject

// 启用系统待机功能
+ (void) enableSysIdle:(NSDictionary *)params;

// 取int属性值
+ (int) getIntProperty:(NSDictionary *)params;

// 取string属性值
+ (NSString *) getStringProperty:(NSDictionary *)params;

// 复制app内的文件
+ (void) copyAppFilesTo:(NSDictionary *)params;
+ (void) asynCopyAppFilesTo:(NSDictionary *)params;
+ (void) asynCopyCheck;

@end
