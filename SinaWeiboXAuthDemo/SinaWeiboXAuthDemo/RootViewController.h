//
//  RootViewController.h
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboEngine.h"
#import "SinaWeiboClient.h"
#import "Status.h"
#import "AddXAuthAccountViewController.h"
#import "UIImageView+WebCache.h"

@interface RootViewController : UITableViewController <SDImageCacheDelegate>
{
	NSMutableArray *statuses;
    SinaWeiboClient *weiboClient;
    
    AddXAuthAccountViewController *addUserViewController;
}

@property (nonatomic, retain) IBOutlet AddXAuthAccountViewController *addUserViewController;

- (void)openAuthenticateView;

- (IBAction)refresh:(id)sender;

- (IBAction)compose:(id)sender;


@end
