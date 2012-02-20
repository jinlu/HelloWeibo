//
//  TestSubView.h
//  test_client 
//
//  Created by JinLu on 11-6-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionLabel.h"
#import "NodeParser.h"

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define COLOR_AT COLOR(87,107,149,1)

enum {FACE_COUNT = 33};
static NSString * arryFace[] =
{
    @"(开心)",
    @"(萌)",
    @"(大笑)",
    @"(囧)",
    @"(坏笑)",
    @"(YY)",
    @"(想你)",
    @"(色)",
    @"(震惊)",
    @"(睡觉)",
    @"(汗)",
    @"(晕)",
    @"(哼哼)",
    @"(哭泣)",
    @"(纠结)",
    @"(委屈)",
    @"(阴险地笑)",
    @"(大哭)",
    @"(愤怒)",
    @"(猪头)",
    @"(太阳)",
    @"(生日快乐)",
    @"(芳心)",
    @"(彩虹)",
    @"(绿色心情)",
    @"(玫瑰花)",
    @"(洗具)",
    @"(旅行)",
    @"(杯具)",
    @"(下雨)",
    @"(干杯)",
    @"(赞扬)",
    @"(星星)",
};

#define HTOKENARRY NSArray* 

@interface RichTextLabel : UIView <ActionLabelDelegate> 
{
    
}

- (void)richTextSetDemoInfo;

// node (文本，表情，链接)
// nodes node array
- (void)richTextSetNodes:(NSArray *)nodes;
- (void)richTextSetNodes:(NSArray *)nodes 
              startPoint:(CGPoint)startPoint 
          endPointReturn:(CGPoint*)endPointReturn;

- (void)richTextSetTextNode:(NSString *)text;
// (星星)
- (void)richTextSetFaceNode:(NSString *)faceType;
- (void)richTextSetLinkNode:(NSString *)url;

@end
