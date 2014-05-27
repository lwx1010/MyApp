//
//  KY_CountAnalytics.h
//  qudao
//
//  Created by KY_ljf on 13-11-12.
//  Copyright (c) 2013年 youran. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KY_CountAnalytics : NSObject

+(void)initAnalytics;

+(void)onLoginAnalytics:(NSString *)userId;

+(void)onRegisterAnalytics:(NSString *)userId;


//安装识别方法：

//返回值：
//0                            表示该应用不是快用安装的
//1                            表示该应用是由快用安装的，并且没有执行过统计
//2                   表示该应用是由快用安装的，已经执行过统计
//3                           表示标记设备时失败
//4                       表示上报日志时失败
//5                                   表示已成功走完全部流程
+(int)checkInstallIden;
@end
