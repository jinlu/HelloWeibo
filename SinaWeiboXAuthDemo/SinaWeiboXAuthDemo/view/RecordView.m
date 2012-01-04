//
//  RecordView.m
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-1-3.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import "RecordView.h"
#import "NodeFactory.h"
#import "UIImageView+WebCache.h"

@implementation RecordView

@synthesize contentLabel;
@synthesize nameLabel;
@synthesize logoImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float posY = 10;
        float posX = 5;
        logoImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 40, 40)] autorelease];
        [self addSubview:logoImageView];
        // Initialization code
        nameLabel = [[[RichTextLabel alloc] initWithFrame:CGRectMake(posX + 40 + 10, posY, self.frame.size.width, 20)] autorelease];
        [self addSubview:nameLabel];
        posY += 16;
        posY += 10;
        contentLabel = [[[RichTextLabel alloc] initWithFrame:CGRectMake(posX + 40 + 10, posY, self.frame.size.width - 40 - 2*10 , 200)] autorelease];
        [self addSubview:contentLabel];

        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(posX + 40 + 10, posY, 100, 100)] autorelease];
        [self addSubview:imageView];
        
        subView = [[[RecordSubView alloc] initWithFrame:CGRectMake(posX + 40 + 10, posY, 
                                                                   contentLabel.frame.size.width, 
                                                                   100)] autorelease];
        [self addSubview:subView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setInfo:(Status *)status
{
    NSString *logoUrl = status.user.profileImageUrl;
    [logoImageView setImageWithURL:[NSURL URLWithString:logoUrl]];
    
    float posY = 0;
    NSArray *nodes = [NodeFactory generateTextNodes:status.user.screenName];
    [nameLabel richTextSetInfo:nodes];
    posY += logoImageView.frame.size.height; 
    nodes = [NodeFactory generateTextNodes:status.text];
    
    [contentLabel richTextSetInfo:nodes];
    posY += contentLabel.frame.size.height;

    if (status.thumbnailPic && [status.thumbnailPic length] > 0)
    {
        CGRect frame = imageView.frame;
        [imageView setFrame:CGRectMake(frame.origin.x, posY, frame.size.width, frame.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:status.thumbnailPic]];
        posY += imageView.frame.size.height;
    }
        
    if (status.retweetedStatus)
    {
        [subView setHidden:NO];
        [subView setInfo:status.retweetedStatus];
    }
    else
    {
        [subView setHidden:YES];        
    }    
    
    if (!subView.hidden) 
    {
        posY += 5;
        CGRect subRecordFrame = subView.frame;
        [subView setFrame:CGRectMake(contentLabel.frame.origin.x, 
                                   posY, 
                                   contentLabel.frame.size.width, 
                                   subRecordFrame.size.height)];
        posY += subRecordFrame.size.height;
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, posY);
}

- (void)dealloc
{
    [super dealloc];
}
@end
