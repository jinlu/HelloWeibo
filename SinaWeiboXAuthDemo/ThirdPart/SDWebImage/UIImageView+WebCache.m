/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"

@protocol SDImageDownloadDelegate <NSObject>
- (void)imageDownloadSuccess:(UIView *)view;
- (void)imageDownloadFail:(UIView *)view;
@end

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{    
    self.image = image;            
//    CGRect frame = self.frame;
//    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, image.size.width, image.size.height)];
    
//    UIView *view = self;
//    while (view != nil && ![view isKindOfClass:[UIWindow class]])
//    {
//        view = [view superview];
//        if ([view isKindOfClass:[UITableView class]])
//        {
//            [(id)view reloadData];
//            break;
//        }
//    }
}

@end
