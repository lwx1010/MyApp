/****************************************************************************
 Copyright (c) 2010-2011 cocos2d-x.org
 Copyright (c) 2010      Ricardo Quesada

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "RootViewController.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#import "PPSdk.h"


@implementation RootViewController

// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationLandscapeRight==interfaceOrientation;
}

// For ios6.0 and higher, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations
{
#ifdef __IPHONE_6_0
    return UIInterfaceOrientationMaskLandscapeRight;
#endif
}

- (BOOL) shouldAutorotate {
    return YES;
}

//fix not hide status on ios7
- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark    ---------------SDK CALLBACK---------------
//字符串登录成功回调【实现其中一个就可以】
- (void)ppLoginStrCallBack:(NSString *)paramStrToKenKey{
    NSLog(paramStrToKenKey);
    
    [PPSdk callLua:@"login" retStr:paramStrToKenKey];
    
    //字符串token验证方式
//    MSG_GAME_SERVER_STR mgs_s = {};
//    mgs_s.len_str =  41;
//    mgs_s.commmand_str = 0xAA000022;
//    memcpy(mgs_s.token_key_str, [paramStrToKenKey UTF8String], 33);
    //下面请注意，登录验证分两种情况e
    //1. 如果您没有业务服务器则在此处直接跳入游戏界面
    //2. 如果您有游戏服务器，请在这里验证登录信息，然后跳转到游戏界面
    //下面代码为内部服务器测试代码
//    int fd = socket( AF_INET , SOCK_STREAM , 0 ) ;
//    if(fd == -1)
//        printf("socket err : %m\n"),exit(1);
//    struct sockaddr_in addr;
//    addr.sin_family = AF_INET;
//    addr.sin_port = htons([GAMESERVER_PORT_TEST intValue]);
//    addr.sin_addr.s_addr = inet_addr(GAMESERVER_IP_TEST);
//    int r = connect(fd, (struct sockaddr *)&addr, sizeof(addr));
//    if(r == -1)
//        printf("connect err : %m\n"),exit(-1);
//    
//    //发送验证
//    send(fd, &mgs_s, sizeof(MSG_GAME_SERVER_STR), 0);
//    MSG_GAME_SERVER_RESPONSE mgsr;
//    recv(fd, &mgsr, 12, 0);
//    NSLog(@"%02X",mgsr.status);
//    if(mgsr.status == 0){
//        //跳入游戏界面
//        [bgGanmeCenterImageView setHidden:NO];
//        [bgloginImageView setHidden:YES];
//        [[PPAppPlatformKit sharedInstance] getUserInfoSecurity];
//    }
}

//2进制登录成功回调【实现其中一个就可以】
//- (void)ppLoginHexCallBack:(char *)paramHexToKen{
//
//    MSG_GAME_SERVER mgs = {};
//    mgs.len =  24;
//    mgs.commmand = 0xAA000021;
//    memcpy(mgs.token_key, paramHexToKen, 16);
//
//    //下面请注意，登录验证分两种情况e
//    //1. 如果您没有业务服务器则在此处直接跳入游戏界面
//    //2. 如果您有游戏服务器，请在这里验证登录信息，然后跳转到游戏界面
//    //下面代码为内部服务器测试代码
//    int fd = socket( AF_INET , SOCK_STREAM , 0 ) ;
//    if(fd == -1)
//        printf("socket err : %m\n"),exit(1);
//    struct sockaddr_in addr;
//    addr.sin_family = AF_INET;
//    addr.sin_port = htons([GAMESERVER_PORT_TEST intValue]);
//    addr.sin_addr.s_addr = inet_addr(GAMESERVER_IP_TEST);
//    int r = connect(fd, (struct sockaddr *)&addr, sizeof(addr));
//    if(r == -1)
//        printf("connect err : %m\n"),exit(-1);
//    //发送验证
//    send(fd, &mgs, sizeof(MSG_GAME_SERVER), 0);
//    MSG_GAME_SERVER_RESPONSE mgsr;
//    recv(fd, &mgsr, 12, 0);
//    NSLog(@"%02X",mgsr.status);
//    if(mgsr.status == 0){
//        //跳入游戏界面
//        [bgGanmeCenterImageView setHidden:NO];
//        [bgloginImageView setHidden:YES];
//        [[PPAppPlatformKit sharedInstance] getUserInfoSecurity];
//    }
//}

//关闭客户端页面回调方法
-(void)ppClosePageViewCallBack:(PPPageCode)paramPPPageCode{
    //可根据关闭的VIEW页面做你需要的业务处理
    NSLog(@"当前关闭的VIEW页面回调是%d", paramPPPageCode);
    
    NSString * ret = [[NSString alloc] initWithFormat:@"%d", paramPPPageCode];
    
    [PPSdk callLua:@"page" retStr:ret];
}



//关闭WEB页面回调方法
- (void)ppCloseWebViewCallBack:(PPWebViewCode)paramPPWebViewCode{
    //可根据关闭的WEB页面做你需要的业务处理
    NSLog(@"当前关闭的WEB页面回调是%d", paramPPWebViewCode);
    
    NSString * ret = [[NSString alloc] initWithFormat:@"%d", paramPPWebViewCode];
    
    [PPSdk callLua:@"web" retStr:ret];
}

//注销回调方法
- (void)ppLogOffCallBack{
    NSLog(@"注销的回调");
//    [bgGanmeCenterImageView setHidden:YES];
//    [bgloginImageView setHidden:NO];
    
    [PPSdk callLua:@"logoff" retStr:@"0"];
}

//兑换回调接口【只有兑换会执行此回调】
- (void)ppPayResultCallBack:(PPPayResultCode)paramPPPayResultCode{
    NSLog(@"兑换回调返回编码%d",paramPPPayResultCode);
    //回调购买成功。其余都是失败
//    if(paramPPPayResultCode == PPPayResultCodeSucceed){
//        //购买成功发放道具
//        
//    }else{
//        
//    }
    
    NSString * ret = [[NSString alloc] initWithFormat:@"%d", paramPPPayResultCode];
    
    [PPSdk callLua:@"pay" retStr:ret];
}

-(void)ppVerifyingUpdatePassCallBack{
    NSLog(@"验证游戏版本完毕回调");
//    [[PPAppPlatformKit sharedInstance] showLogin];
    
    [PPSdk setUpdateEnd:TRUE];
    
    [PPSdk callLua:@"verify" retStr:@"0"];
}

@end
