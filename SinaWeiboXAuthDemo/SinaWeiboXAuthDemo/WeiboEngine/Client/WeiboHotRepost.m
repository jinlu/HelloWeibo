//
//  WeiboHotRepost.m
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-2-6.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import "WeiboHotRepost.h"
#import "SinaWeiboClient.h"


@implementation WeiboHotRepost

- (void)dealloc 
{
	[super dealloc];
}

+ (WeiboHotRepost *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction
									  oAuth:(OAuth *)_oAuth 
{
	WeiboHotRepost *connection = [[[WeiboHotRepost alloc]initWithDelegate:aDelegate
																	 action:anAction
                                                                      oAuth:_oAuth] autorelease];
	return connection;
}

+ (WeiboHotRepost *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction 
{
	WeiboHotRepost *connection = [[[WeiboHotRepost alloc]initWithDelegate:aDelegate
																	 action:anAction] autorelease];
	return connection;
}


- (void)processError:(NSDictionary *)dic 
{
	NSString *msg = [dic objectForKey:@"error"];
	if (msg) 
    {
		NSLog(@"Weibo responded with an error: %@", msg);
		int errorCode = 0;//[[dic objectForKey:@"error_code"] intValue];
		NSRange range = [msg rangeOfString:@":"];
		
        if (range.length == 1 && range.location != NSNotFound) 
        {
			errorCode = [[msg substringToIndex:range.location] intValue];
		}
        
		hasError = true;
		switch (errorCode) 
        {
			default: 
				self.errorMessage = @"Weibo Server Error";
				self.errorDetail  = msg;
				break;					
		}
	}
}

- (NSString *)baseUrl 
{
	return @"http://api.t.sina.com.cn/";
}


#pragma mark -
#pragma mark overide public methods

- (void)verifyCredentials 
{
	[self asyncGet:@"account/verify_credentials.json" params:nil];
}

- (void)getHotRepost
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[super asyncGet:@"statuses/hot/repost_daily.json" params:params];    
}


@end
