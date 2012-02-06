//
//  RootViewController.h
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboEngine.h"
#import "WeiboLogin.h"
#import "SinaWeiboClient.h"
#import "Status.h"
#import "AddXAuthAccountViewController.h"
#import "UIImageView+WebCache.h"

@interface RootViewController : UIViewController <SDImageCacheDelegate, WeiboLoginDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView                     *myTableView;
    UIView                          *loadingView;
    UIActivityIndicatorView         *indicatorView;
	NSMutableArray                  *statuses;
    SinaWeiboClient                 *weiboClient;    
}

@property(nonatomic,retain) IBOutlet UITableView *myTableView;

@property(nonatomic,retain) IBOutlet UIView *loadingView;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

- (IBAction)refresh:(id)sender;

- (IBAction)compose:(id)sender;

@end
