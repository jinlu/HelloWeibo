//
//  WeiboLogin.h
//  SinaWeiboXAuthDemo
//
//  Created by jinlu 12-02-02.
//  Copyright 2012年 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboEngine.h"
#import "WeiboConnection.h"
#import "SinaWeiboOAuth.h"
#import "SynthesizeSingleton.h"

@protocol WeiboLoginDelegate <NSObject>
- (void) weibologinSuccess;
- (void) weibologinFail;
@end

@interface WeiboLogin : NSObject <OAuthCallbacks> 
{
	OAuth                   *oAuth;	
	NSOperationQueue        *queue;
    id <WeiboLoginDelegate> delegate;
}

@property (nonatomic, retain) OAuth *oAuth;
@property (nonatomic, assign) id <WeiboLoginDelegate> delegate;

- (void)loginStart;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WeiboLogin);

@end
