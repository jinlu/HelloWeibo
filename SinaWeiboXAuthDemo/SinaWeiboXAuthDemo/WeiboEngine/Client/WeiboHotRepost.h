//
//  WeiboHotRepost.h
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-2-6.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboConnection.h"

@interface WeiboHotRepost : WeiboConnection 
{
    
}

+ (WeiboHotRepost *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction
									  oAuth:(OAuth *)_oAuth;

+ (WeiboHotRepost *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction;

- (void)getHotRepost;

@end
