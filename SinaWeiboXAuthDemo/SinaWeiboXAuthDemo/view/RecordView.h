//
//  RecordView.h
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-1-3.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextLabel.h"
#import "Status.h"
#import "RecordSubView.h"

@interface RecordView : UIView
{
    UIImageView   *logoImageView;
    RichTextLabel *nameLabel;
    RichTextLabel *contentLabel;        
    UIImageView   *imageView; 
    RecordSubView *subView;
}

@property(nonatomic,retain) RichTextLabel *nameLabel;
@property(nonatomic,retain) RichTextLabel *contentLabel;
@property(nonatomic,retain) UIImageView   *logoImageView;

- (void)setInfo:(Status *)status;

@end
