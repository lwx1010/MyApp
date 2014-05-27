#import "CCPlayVideoView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CCLuaStack.h"
#import "CCLuaValue.h"
#import "CCLuaBridge.h"

using cocos2d::CCLuaBridge;
using cocos2d::CCLuaValue;
using cocos2d::CCLuaStack;


static CCPlayVideoView* playVideoView;
static MPMoviePlayerController* videoView;
static int videoLuaCallBack = 0;
static NSDictionary* videoLuaCallBackParams = nil;
static NSString* videoLuaCallBackFunName = nil;
static UILabel* glabel = nil;


@implementation CCPlayVideoView

+(void)playVideo:(NSDictionary*)params
{
    [params retain];
    NSString* filepath = [params objectForKey:@"filepath"];
    NSString* funname = [params objectForKey:@"callBackFunName"];
    videoLuaCallBackFunName = funname;
    
    if(videoLuaCallBackFunName != nil)
    {
        [videoLuaCallBackFunName release];
        videoLuaCallBackFunName = nil;
    }
    
    if(funname != nil)
        videoLuaCallBackFunName = [[NSString alloc] initWithString:funname];
    //[cacheString retain];
    //videoLuaCallBackFunName = [cacheString UTF8String];
    
    if(filepath == nil) return;
    
    if(playVideoView != nil)
    {
        [playVideoView release];
        playVideoView = nil;
    }
    
    if(videoView != nil)
    {
        [videoView release];
        videoView = nil;
    }
    
    UIWindow* _window = [UIApplication sharedApplication].keyWindow;
    
    CGRect viewArea = [_window bounds];
    
    NSString* path = [NSString stringWithFormat:filepath, NSHomeDirectory()];
    
    if(path == nil) return;
    
    playVideoView = [[CCPlayVideoView alloc] initWithFrame:viewArea];
    [playVideoView setBackgroundColor:[UIColor yellowColor]];
    [_window addSubview:playVideoView];
    
    //videoView = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    videoView = [[MPMoviePlayerController alloc] init];
    videoView.movieSourceType = MPMovieSourceTypeFile;
    videoView.contentURL = [NSURL fileURLWithPath:path];
    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
    videoView.view.transform = landscapeTransform;
    videoView.scalingMode = MPMovieScalingModeFill;
    videoView.movieControlMode = MPMovieControlModeHidden;
    [videoView.view setFrame:[_window bounds]];
    videoView.initialPlaybackTime = -1;
    [playVideoView addSubview:videoView.view];
    
    viewArea = [videoView.view bounds];
    CCPlayVideoLabel *label = [[CCPlayVideoLabel alloc] initWithFrame:CGRectMake(0, 0, viewArea.size.width, viewArea.size.height)];
    [videoView.view addSubview:label];
    
    glabel = label;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:playVideoView selector:@selector(VideoFinishedCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoView];
    
    [[NSNotificationCenter defaultCenter] addObserver:playVideoView selector:@selector(VideoFinishedCallBack:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:playVideoView selector:@selector(VideoChangeOrientation:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [videoView play];
    
}

+(void)playVideoCallBack
{
    if(videoLuaCallBackFunName != nil)
    {
        cocos2d::CCLuaBridge::getStack()->executeGlobalFunction([videoLuaCallBackFunName UTF8String]);
        
        [videoLuaCallBackFunName release];
        videoLuaCallBackFunName = nil;
    }
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{

//}

-(void)VideoFinishedCallBack:(NSNotification *)notify
{
    //MPMoviePlayerController* theVideo = [notify object];
    [[NSNotificationCenter defaultCenter] removeObserver:playVideoView name:MPMoviePlayerPlaybackDidFinishNotification object:videoView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:playVideoView name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:playVideoView name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [CCPlayVideoView playVideoCallBack];
    
    [glabel removeFromSuperview];
    [glabel release];
    glabel = nil;
    
    [videoView.view removeFromSuperview];
    [videoView stop];
    videoView = nil;
    
    [playVideoView removeFromSuperview];
    [playVideoView release];
    playVideoView = nil;
}

-(void)VideoChangeOrientation:(NSNotification *)notify
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
        [videoView.view setTransform: CGAffineTransformMakeRotation(M_PI*1.5)];
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight) {
         [videoView.view setTransform: CGAffineTransformMakeRotation(M_PI/2)];    }
}

+(void)registerLuaCallBack:(NSDictionary*)n
{
    if(videoLuaCallBack != 0)
    {
        CCLuaBridge::releaseLuaFunctionById(videoLuaCallBack);
    }
    
    videoLuaCallBack = [[n objectForKey:@"callback"] intValue];
    
    if(videoLuaCallBack != 0)
    {
        cocos2d::CCLuaBridge::retainLuaFunctionById(videoLuaCallBack);
    }
}

@end

@implementation CCPlayVideoLabel

-(id) initWithFrame:(CGRect)frame
{
    NSString *text = @"跳过动画";
    UIFont *font = [UIFont systemFontOfSize:14];
    
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newFrame = CGRectMake(frame.size.width - (labelSize.width * 5 / 4), 10, labelSize.width, labelSize.height);
    
    if(self = [super initWithFrame:newFrame]) {
        self.userInteractionEnabled = YES;
        self.adjustsFontSizeToFitWidth = NO;
        self.textAlignment = NSTextAlignmentLeft;
        self.font = font;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.text = text;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] removeObserver:playVideoView name:MPMoviePlayerPlaybackDidFinishNotification object:videoView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:playVideoView name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:playVideoView name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [glabel removeFromSuperview];
    [glabel release];
    glabel = nil;
    
    [CCPlayVideoView playVideoCallBack];
    [videoView.view removeFromSuperview];
    [videoView stop];
    videoView = nil;
    
    [playVideoView removeFromSuperview];
    [playVideoView release];
    playVideoView = nil;
}

-(void)dealloc {
    [super dealloc];
}

@end