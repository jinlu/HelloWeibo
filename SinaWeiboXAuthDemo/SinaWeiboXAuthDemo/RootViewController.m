//
//  RootViewController.m
//  SinaWeiboXAuthDemo
//
//  Created by junmin liu on 11-5-26.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "RootViewController.h"
#import "CustomCell.h"
#import "EGORefreshTableHeaderView.h"

@interface RootViewController (private)
-(void)weiboLogin;
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
    
    //添加刷新状态显示视图，隐藏在TableView后面
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, 320.0f, myTableView.bounds.size.height)];
    [refreshHeaderView setDelegate:self];
    refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self.myTableView addSubview:refreshHeaderView];
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
    
	weiboClient = [[WeiboHotRepost alloc] initWithDelegate:self 
                                                    action:@selector(timelineDidReceive:obj:)];
	[weiboClient getHotRepost];
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

- (void)timelineDidReceive:(WeiboHotRepost*)sender obj:(NSObject*)obj
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
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
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
    [refreshHeaderView removeFromSuperview];
    [refreshHeaderView release];
	refreshHeaderView = nil;
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

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
#warning isloading 
    return NO;
}


- (IBAction)refresh:(id)sender 
{
	[self loadData];
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
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}

@end
