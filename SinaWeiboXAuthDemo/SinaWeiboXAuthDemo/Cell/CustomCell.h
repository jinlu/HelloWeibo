//
//  CustomCell.h
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 11-12-23.
//  Copyright (c) 2011年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordView.h"
#import "RecordSubView.h"

@interface CustomCell : UITableViewCell
{
    RecordView      *recordView;
}

- (void)setInfo:(Status *)status;

@end
