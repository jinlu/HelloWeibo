//
//  ActionLabel.m
//  TestView
//
//  Created by JinLu on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ActionLabel.h"

@implementation ActionLabel

@synthesize delegate;
@synthesize oldColor;
@synthesize attachData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // important
        [self setUserInteractionEnabled:YES];
    }
    return self;
}


- (void)dealloc
{
    [oldColor release];
    [attachData release];
    [super dealloc]; 
}

- (void)restoreColor
{
    if (oldColor != nil)
    {
        [self setTextColor:oldColor];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.oldColor =  [self textColor];
    [self setTextColor:[UIColor blueColor]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];    
    [self performSelector:@selector(restoreColor) withObject:nil afterDelay:0.2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(restoreColor) withObject:nil afterDelay:0.2];
    
    if ([delegate respondsToSelector:@selector(actionLabel:attachData:)])
    {
        [delegate actionLabel:self attachData:attachData];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesMoved:touches withEvent:event];
}

@end
