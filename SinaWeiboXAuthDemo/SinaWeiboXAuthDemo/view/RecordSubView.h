//
//  RecordSubView.h
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-1-3.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextLabel.h"
#import "Status.h"

@interface RecordSubView : UIView
{
    RichTextLabel *nameLabel;
    RichTextLabel *richLabel;
    UIImageView   *imageView;
}

@property(nonatomic,retain) RichTextLabel *richLabel;
@property(nonatomic,retain) RichTextLabel *nameLabel;

- (void)setInfo:(Status *)status;

@end