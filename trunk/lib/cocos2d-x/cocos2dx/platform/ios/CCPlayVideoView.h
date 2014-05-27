#ifndef __CC_PLAYVIDEO_VIEW_H__
#define __CC_PLAYVIDEO_VIEW_H__
#import <UIKit/UIKit.h>

@interface CCPlayVideoView : UIView

-(void)VideoFinishedCallBack:(NSNotification*)notify;
-(void)VideoChangeOrientation:(NSNotification*)notify;
+(void)playVideo:(NSDictionary*)params;
+(void)registerLuaCallBack:(NSDictionary*)n;
+(void)playVideoCallBack;

@end

@interface CCPlayVideoLabel : UILabel

@end
#endif