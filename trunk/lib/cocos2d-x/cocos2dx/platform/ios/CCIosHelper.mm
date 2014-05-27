
#import "CCIosHelper.h"
#import "CCLuaBridge.h"
#import "CCLuaStack.h"
#import "CCLuaValue.h"

@implementation CCIosHelper

+ (void) enableSysIdle:(NSDictionary *)params
{
    BOOL disable = ![[params objectForKey:@"enable"] boolValue];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:disable];
}

+ (int) getIntProperty:(NSDictionary *)params
{
    NSString *key = [params objectForKey:@"key"];
    if( key==nil )
    	return 0;
    
    NSString *valStr = [[NSBundle mainBundle]objectForInfoDictionaryKey:key];
    if( valStr==nil )
    	return 0;
    
    return [valStr intValue];
}

+ (NSString*) getStringProperty:(NSDictionary *)params
{
    NSString *key = [params objectForKey:@"key"];
    if( key==nil )
    	return NULL;
    
    return [[NSBundle mainBundle]objectForInfoDictionaryKey:key];
}

static NSString* s_copyRet = nil;
static NSTimer* s_copyTimer = nil;
static int s_copyLuaCallback = 0;

+ (void) asynCopyAppFilesTo:(NSDictionary *)params
{
	NSString *from = [params objectForKey:@"from"];
    NSString *to = [params objectForKey:@"to"];
    if( from==nil || to==nil )
	{
        s_copyRet = @"params error";
		return;
	}
    
    NSString* frompath = [[NSBundle mainBundle] pathForResource:from ofType:nil];
    if( frompath==nil )
	{
        s_copyRet = @"from path not exist";
		return;
	}
    
    NSError *err;
    BOOL ret = [[NSFileManager defaultManager] copyItemAtPath:frompath toPath:to error:&err];
    if( ret==YES )
	{
        s_copyRet = @"success";
		return;
	}
    
    if( err!=nil )
    {
        s_copyRet = err.description;
    }
    
    s_copyRet = @"unknown error";
}

+ (void) asynCopyCheck
{
	if( s_copyRet==nil )
		return;
    
	[s_copyTimer invalidate];
	s_copyTimer = nil;
	
	if( s_copyLuaCallback<=0 )
        return;
    
    cocos2d::CCLuaBridge::pushLuaFunctionById(s_copyLuaCallback);
    
    cocos2d::CCLuaStack *stack = cocos2d::CCLuaBridge::getStack();
    stack->pushString([s_copyRet UTF8String]);
    stack->executeFunction(1);
	
	cocos2d::CCLuaBridge::releaseLuaFunctionById(s_copyLuaCallback);
	s_copyLuaCallback = 0;
	s_copyRet = nil;
}

+ (void) copyAppFilesTo:(NSDictionary *)params
{
	if( s_copyTimer )
		return;
    
	NSNumber *callback = [params objectForKey:@"callback"];
    s_copyLuaCallback = [callback intValue];
	
	s_copyTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(asynCopyCheck) userInfo:nil repeats:YES];
    
	s_copyRet = nil;
	[NSThread detachNewThreadSelector:@selector(asynCopyAppFilesTo:) toTarget:self withObject:params];
}

@end