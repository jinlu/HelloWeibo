//
//  CustomCell.m
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 11-12-23.
//  Copyright (c) 2011年 Openlab. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        recordView = [[[RecordView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)] autorelease];
        [self addSubview:recordView];
    }
    return self;
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)mylayout
{
    const float TOP_BOTTOM = 5.0;
    float posY = 0;
    posY += TOP_BOTTOM;
    CGRect recordFrame = recordView.frame;
    [recordView setFrame:CGRectMake(0, posY, recordFrame.size.width, recordFrame.size.height)];
    posY += recordFrame.size.height;
    posY += TOP_BOTTOM;
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, posY);
}

- (void)setInfo:(Status *)status
{
    [recordView setInfo:status];
    [self mylayout];
}

- (void)dealloc
{
    [super dealloc];
}

@end
