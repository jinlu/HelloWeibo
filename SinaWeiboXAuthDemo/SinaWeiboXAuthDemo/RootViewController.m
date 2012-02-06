//
//  RootViewController.m
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "RootViewController.h"
#import "CustomCell.h"

@interface RootViewController (private)
- (void)weiboLogin;
@end

@implementation RootViewController
@synthesize myTableView;
@synthesize loadingView;
@synthesize indicatorView;

- (void)viewDidLoad
{ 
    [super viewDidLoad];

    if (!statuses) 
    {
		statuses = [[NSMutableArray alloc] init];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self performSelector:@selector(loadTimeline) withObject:nil afterDelay:0.5];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)loadData 
{
	if (weiboClient) 
    { 
		return;
	}
    
	weiboClient = [[SinaWeiboClient alloc] initWithDelegate:self 
											   action:@selector(timelineDidReceive:obj:)];
	[weiboClient getFollowedTimelineSinceID:0 
							 startingAtPage:0 count:500];
}

- (void)loadTimeline 
{
    WeiboEngine *engine = [WeiboEngine engine];
	if (!engine.isAuthorized) 
    {
        [self weiboLogin];
    }
	else 
    {
		NSLog(@"Authenicated for %@..", engine.user.screenName);
		[self loadData];		
	}
}


- (void)followDidReceive:(SinaWeiboClient*)sender obj:(NSObject*)obj 
{
	if (sender.hasError) 
    {		
		NSLog(@"followDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) 
    {
		NSLog(@"followDidReceive data format error.%@", @"");
        return;
    }
    
    
    NSDictionary *dic = (NSDictionary*)obj;
	User *responseUser = [[[User alloc]initWithJsonDictionary:dic] autorelease];
	NSLog(@"follow user success:.%@", responseUser.screenName);
}

- (void)timelineDidReceive:(SinaWeiboClient*)sender obj:(NSObject*)obj
{    
    if (sender.hasError) 
    {		
        if (sender.statusCode == 401) 
        {
            [self weiboLogin];
        }
    }
	weiboClient = nil;
    
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) 
    {
        return;
    }
    
	NSArray *ary = (NSArray*)obj;  
	
	[statuses removeAllObjects];
	
	for (int i = [ary count] - 1; i >= 0; --i) 
    {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) 
        {
			continue;
		}
        
		Status* sts = [Status statusWithJsonDictionary:[ary objectAtIndex:i]];
		[statuses insertObject:sts atIndex:0];
	}		
    
    [loadingView setHidden:YES];
	[myTableView reloadData];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return statuses.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

	Status *sts = [statuses objectAtIndex:indexPath.row];        
    [cell setInfo:sts];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
	Status *sts = [statuses objectAtIndex:indexPath.row];
    [cell setInfo:sts];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [myTableView release];
    myTableView = nil;
    [loadingView release];
    loadingView = nil;
    [self setIndicatorView:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [statuses release];
    [weiboClient release];
    [myTableView release];
    [loadingView release];
    [indicatorView release];
    [super dealloc];
}

- (IBAction)refresh:(id)sender 
{
	[self loadData];
}

- (IBAction)compose:(id)sender 
{
    
}

- (void)imageDownloadSuccess:(UIView *)view
{
    [myTableView reloadData];
}

- (void)imageDownloadFail:(UIView *)view
{
    
}

#pragma mark - Log In

- (void)weiboLogin
{
    [[WeiboLogin sharedInstance] loginStart];
    [[WeiboLogin sharedInstance] setDelegate:self];    
    [loadingView setHidden:NO];
    [indicatorView startAnimating];
}

- (void)weibologinSuccess
{
    [self loadData];		
}

- (void)weibologinFail
{
    NSString *title = @"认证失败";
	NSString *msg = @"登录失败，请重试！";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [loadingView setHidden:YES];
}
@end
