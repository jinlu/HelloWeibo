//
//  NodeParser.h
//  TestView
//
//  Created by JinLu on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

enum {SUBVIEW_TOP = 10};
enum {SUBVIEW_BOT = 10};

//// nodes 结构的其他 type 含义
//PLAT_PT_TYPE_TEXT	= 0,	// 文本
//PLAT_PT_TYPE_AT		= 1,	// 提到（@abc）
//PLAT_PT_TYPE_TOPIC	= 2,	// 聊吧（讨论组）
//PLAT_PT_TYPE_LINK	= 3,	// 链接

#define PLAT_PT_TYPE_TEXT (0)
#define PLAT_PT_TYPE_AT (1)
#define PLAT_PT_TYPE_TOPIC (2)
#define PLAT_PT_TYPE_LINK (3)
#define PLAT_PT_TYPE_ICON (100020)

#define COLOR_SCHEME_DEFAULT (0)
#define COLOR_SCHEME_AT (1)
#define COLOR_SCHEME_LINK (2)

#define SYSTEM_FONT_SIZE (14)

#define LINE_SPACE (6)

#define FACE_WIDTH (19)
#define FACE_HEIGHT (19)

#define LINK_ICON_WIDTH (16)
#define LINK_ICON_HEIGHT (7)


@interface NodeParser : NSObject {
    
}

+ (NSArray *)parseAtNode:node 
             startPostion:(CGPoint)postion 
                 fitWidth:(CGFloat)maxFitWidth 
                     font:(UIFont*)font 
             heightReturn:(CGFloat*) heightReturn 
         endPostionReturn:(CGPoint*)endPostion; 

+ (NSArray *)parseStringNode:(NSDictionary *)node 
                 startPostion:(CGPoint)postion 
                     fitWidth:(CGFloat)maxFitWidth 
                         font:(UIFont*)font 
                 heightReturn:(CGFloat*)heightReturn 
             endPostionReturn:(CGPoint*)endPostion; 

+ (NSArray *)parseFaceNode:(NSDictionary *)node 
               startPostion:(CGPoint)postion 
                   fitWidth:(CGFloat)maxFitWidth 
                       font:(UIFont*)font 
               heightReturn:(CGFloat*)heightReturn 
           endPostionReturn:(CGPoint*)endPostion; 

+ (NSArray *)parseLinkNodeFull:(NSDictionary *)node 
                   startPostion:(CGPoint)postion 
                       fitWidth:(CGFloat)maxFitWidth 
                           font:(UIFont*)font 
                   heightReturn:(CGFloat*)heightReturn 
               endPostionReturn:(CGPoint*)endPostion; 

+ (NSArray *)parseLinkNode:(NSDictionary *)node 
               startPostion:(CGPoint)postion 
                   fitWidth:(CGFloat)maxFitWidth 
                       font:(UIFont*)font 
               heightReturn:(CGFloat*)heightReturn 
           endPostionReturn:(CGPoint*)endPostion; 

@end
