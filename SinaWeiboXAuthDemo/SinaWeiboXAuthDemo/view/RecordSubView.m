//
//  RecordSubView.m
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-1-3.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#define TOP (10)
#define LEFT (5)

#import "RecordSubView.h"
#import "NodeLib.h"
#import "UIImageView+WebCache.h"

@implementation RecordSubView

@synthesize richLabel;
@synthesize nameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
        float posY = TOP;
        nameLabel = [[[RichTextLabel alloc] initWithFrame:CGRectMake(LEFT, posY, self.frame.size.width-LEFT, 20)] autorelease];
        [self addSubview:nameLabel];

        posY += 16;
        posY += 5;
        richLabel = [[[RichTextLabel alloc] initWithFrame:CGRectMake(LEFT, posY, self.frame.size.width-LEFT, 200)] autorelease];
        [self addSubview:richLabel];
        posY += richLabel.frame.size.height;
        
        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(LEFT, posY, 100, 100)] autorelease];
        [self addSubview:imageView];

    }
    return self;
}

- (void)setInfo:(Status *)retweetedStatus
{    
    float posY = TOP;
    NSArray *nodes = [NodeLib generateTextNodes:retweetedStatus.user.screenName];
    [nameLabel richTextSetInfo:nodes];
    posY += nameLabel.frame.size.height;

    posY += 16;
    posY += 5;
    
    nodes = [NodeLib generateTextNodes:retweetedStatus.text];
    [richLabel richTextSetInfo:nodes];
    posY += richLabel.frame.size.height;
    
    if (retweetedStatus.thumbnailPic && [retweetedStatus.thumbnailPic length] > 0)
    {
        [imageView setHidden:NO];
        CGRect frame = imageView.frame;
        [imageView setFrame:CGRectMake(frame.origin.x, posY, frame.size.width, frame.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:retweetedStatus.thumbnailPic]];
        posY += imageView.frame.size.height;
        posY += TOP;
    }
    else
    {
        [imageView setHidden:YES];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
}

@end
