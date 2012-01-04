//
//  ActionLabel.h
//  TestView
//
//  Created by JinLu on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActionLabel;

@protocol ActionLabelDelegate <NSObject>
@required
- (void)actionLabel:(ActionLabel *)actionLabel attachData:(id)data;
@end

@interface ActionLabel : UILabel 
{
    id      attachData;
    UIColor * oldColor;
    
    id <ActionLabelDelegate> delegate;
}

@property (nonatomic, assign) id <ActionLabelDelegate> delegate;

@property (nonatomic, retain) UIColor * oldColor;
@property (nonatomic, retain) id attachData;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
