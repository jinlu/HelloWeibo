//
//  AddXAuthAccountViewController.m
//  SinaWeiboXAuthDemo
//
//  Created by jinlu on 12-02-02.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "WeiboLogin.h"

@implementation WeiboLogin

SYNTHESIZE_SINGLETON_FOR_CLASS(WeiboLogin);

@synthesize oAuth;
@synthesize delegate;

- (void) dealloc
{
    [queue release];
    [super dealloc];
}

- (id) init
{	
    self = [super init];
    if (self)
    {
        queue = [[NSOperationQueue alloc] init];
    }    
    
    return self;
}

- (void) loginStart
{
    if (!oAuth) 
    {
		oAuth = [[SinaWeiboOAuth alloc]init];
        oAuth.delegate = self;
	}
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"shijl424", @"username",
							  @"42420026", @"password",
							  nil];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousAuthorizeTokenWithUserInfo:)
										object:userInfo];
	
	[queue addOperation:operation];
	[operation release];	
}

- (void)loginFailed 
{    
    if ([delegate respondsToSelector:@selector(weibologinFail)])
    {
        [delegate weibologinFail];
    }
}

- (void) authorizeTokenDidSucceed:(OAuth *)_oAuth 
{
	if (![NSThread isMainThread]) 
    {
		[self performSelectorOnMainThread:@selector(authorizeTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
    [[WeiboEngine engine]setOAuth:_oAuth];
	NSLog(@"authorizeTokenDidSucceed");
	WeiboConnection *connection = [[_oAuth getWeiboConnectionWithDelegate:self 
																   action:@selector(verifyCredentialsResult:obj:)] retain];
	[connection verifyCredentials];		
    
    if ([delegate respondsToSelector:@selector(weibologinSuccess)])
    {
        [delegate weibologinSuccess];
    }
}

- (void) authorizeTokenDidFail:(OAuth *)_oAuth 
{
	if (![NSThread isMainThread]) 
    {
		[self performSelectorOnMainThread:@selector(authorizeTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	NSLog(@"authorizeTokenDidFail");	
    [self loginFailed];
}

- (void) verifyCredentialsResult:(WeiboConnection*)sender 
							 obj:(NSObject*)obj 
{
	if (sender.hasError) 
    {		
		NSLog(@"verifyCredentialsResult error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);        
        [sender release];
		[self loginFailed];
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) 
    {
		NSLog(@"verifyCredentialsResult data format error.%@", @"");
        [sender release];
		[self loginFailed];
        return;
    }
    
    NSDictionary *dic = (NSDictionary*)obj;
	User *user = [User userWithJsonDictionary:dic];
	NSLog(@"user: %@", user.screenName);
	
    [[WeiboEngine engine] setUser:user];	    
}

- (void) requestTokenDidSucceed:(OAuth *)_oAuth 
{
	if (![NSThread isMainThread]) 
    {
		[self performSelectorOnMainThread:@selector(requestTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	NSLog(@"requestTokenDidSucceed");
}

- (void) requestTokenDidFail:(OAuth *)_oAuth 
{
	if (![NSThread isMainThread]) 
    {
		[self performSelectorOnMainThread:@selector(requestTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	NSLog(@"requestTokenDidFail");
}

@end
