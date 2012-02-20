//
//  NodeParser.m
//  TestView
//
//  Created by JinLu on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NodeParser.h"
#import <Foundation/Foundation.h>

@interface NodeParser (private)
+ (NSArray *) stringSplit:(NSArray*)token string:(NSString *)string startPostion:(CGPoint)postion fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn endPostionReturn:(CGPoint*)endPostion; 
+ (NSArray *) stringSplit:(NSArray*)token string:(NSString *)string fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn;  
@end

@implementation NodeParser

/**
 * 
 result (token) 
 
 token 
 {
     [txt]
     [type]
     [prefix]
     [real_name]
     [frames]
 }
 
 frames
 {
     [0] frame
     [1]
     ...
 }
 
 frame
 {
     [x] 
     [y]
     [w]
     [h]
 }
 
 **/


/**
 * @token
 * @string source string  
 * @startPostion start from which to layout string
 * @maxFitWidth max with for string  
 * @font 
 * @heightReturn returned value
 * @endPostionReturn end postion 
 **/

/**
 *   node    
 *      [txt] 有图有真相
 *      [type] 0 
 **/

+ (NSArray *) parseStringNode:(NSDictionary *)node startPostion:(CGPoint)postion fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn endPostionReturn:(CGPoint*)endPostion 
{   
    NSArray *token = [NSArray array];
    if (maxFitWidth <= 0 || node == nil )
    {
        assert(false);
        return nil;
    }
        
    // must be txt type 
    if ([[node valueForKey:@"type"] intValue] != PLAT_PT_TYPE_TEXT)
    {
        assert(false);
        return nil;
    }
    
    NSString * subString = nil; 
    NSString * tmpString = nil;
    NSString * restString = [node valueForKey:@"txt"];

    CGRect subRect = CGRectMake(0, 0, 0, 0);    
    
    NSInteger i = 0;
    
    CGFloat x = postion.x;
    CGFloat y = postion.y;
    
    CGFloat fitwidth = maxFitWidth - x;
    
    while (restString != nil) 
    {
        tmpString = nil;
        subString = nil;
        
        // split restString 
        for ( i=1; i < [restString length] + 1; i++)
        {
            tmpString = [restString substringToIndex:i];
            CGSize size = [tmpString sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
                        
            if (size.width > fitwidth)
            {
                break;
            }
            else
            {
                subString = tmpString;
                subRect.origin.x = x;
                subRect.origin.y = y;
                subRect.size.width = size.width;
                subRect.size.height = size.height;
            }
        }
        
        if (i == [restString length]) 
        {
                        
            // 整个都放里边
            
            NSDictionary * coordinate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:subRect.origin.x], @"x",
                                         [NSNumber numberWithFloat:subRect.origin.y], @"y",
                                         [NSNumber numberWithFloat:subRect.size.width], @"w",
                                         [NSNumber numberWithFloat:subRect.size.height], @"h",
                                         nil];
            
            NSArray * frames = [NSArray arrayWithObject:coordinate];
            
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  restString, @"txt", 
                                  [NSNumber numberWithInt:PLAT_PT_TYPE_TEXT ], @"type",
                                  frames, @"frames",
                                  [NSNumber numberWithInt:COLOR_SCHEME_DEFAULT], @"color",
                                  nil];
            
            token = [token arrayByAddingObject:dic];
            
            [dic release];
            dic = nil;
            
            x += subRect.size.width;
        }        
        else if (subString != nil)
        {   
            
            NSDictionary * coordinate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:subRect.origin.x], @"x",
                                         [NSNumber numberWithFloat:subRect.origin.y], @"y",
                                         [NSNumber numberWithFloat:subRect.size.width], @"w",
                                         [NSNumber numberWithFloat:subRect.size.height], @"h",
                                         nil];
            
            NSArray * frames = [NSArray arrayWithObject:coordinate];
            
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  subString, @"txt", 
                                  [NSNumber numberWithInt:PLAT_PT_TYPE_TEXT], @"type",
                                  frames, @"frames",
                                  [NSNumber numberWithInt:COLOR_SCHEME_DEFAULT],@"color",
                                  nil];
            
            token = [token arrayByAddingObject:dic];
            
            [dic release];
            dic = nil;
            
            x += subRect.size.width;
        }   
        
        // split string 
        // 还有，继续切
        if (i < [restString length])
        {            
            int _height = 0;
            if (subRect.size.height == 0)
            {
                CGSize size = [@"我" sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
                _height = size.height;
            }
            else
            {
                _height = subRect.size.height;
            }
            
            // 一个都放不了
            if (subString == nil)
            {
                // 换行
                x = 0;
                y += _height;
                y += LINE_SPACE;
                fitwidth = maxFitWidth;
            }
            else
            {
                // 继续切
                restString = [restString substringFromIndex:i-1];
                fitwidth = fitwidth - subRect.size.width;
                
                // 放不下了
                if (fitwidth <= 0)
                {
                    x = 0;
                    y += _height;
                    y += LINE_SPACE;
                    fitwidth = maxFitWidth;
                }
            }
        }
        else 
        {
            // finish
            restString = nil;
        }
        
    } //while (restString != nil) 
    
    (*heightReturn) = y + subRect.size.height;
    
    CGPoint pointReturn = CGPointMake(x, y);
    (*endPostion) = pointReturn;
    return token;
}

/**
 * 表情
 * @node
 
     node 
     {
         [txt] "(开心)"
         [type] 100020
     }
 
 **/
// inner use 
+ (NSArray *) parseFaceNode:(NSDictionary *)node startPostion:(CGPoint)postion fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn endPostionReturn:(CGPoint*)endPostion 
{
    NSArray *token = [NSArray array];
    if (node == nil || maxFitWidth <= 0)
    {
        assert(false);
        return nil;
    }
    CGFloat posX = postion.x;
    CGFloat posY = postion.y;
    
    CGSize size = [@"我" sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
    
    // face type
    if ([[node valueForKey:@"type"] intValue] == PLAT_PT_TYPE_ICON)
    {
        NSString * faceText = [node valueForKey:@"txt"];  
        
        if (posX + FACE_WIDTH >= maxFitWidth)
        {
            posX = 0;
            posY += size.height;
            posY += LINE_SPACE;
        }
        
        
        NSDictionary * coordinate = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithFloat:posX], @"x",
                                     [NSNumber numberWithFloat:posY], @"y",
                                     [NSNumber numberWithFloat:FACE_WIDTH], @"w",
                                     [NSNumber numberWithFloat:FACE_HEIGHT], @"h",
                                     nil];
        
        NSArray * frames = [NSArray arrayWithObject:coordinate];
        
        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              faceText, @"txt", 
                              [NSNumber numberWithInt:PLAT_PT_TYPE_ICON ], @"type",
                              frames, @"frames",
                              [NSNumber numberWithInt:COLOR_SCHEME_DEFAULT],@"color",
                              nil];
        
        token = [token arrayByAddingObject:dic];
        
        [dic release];
        dic = nil;
        coordinate = nil;
        frames = nil;
        
        posX += FACE_WIDTH;
        
    }
    
    CGPoint point = CGPointMake(posX, posY);    
    (*endPostion) = point;
    
    (*heightReturn) = posY + size.height;
    
    return token;
}

/**
 * At type node
 *
 * @node
 node 
 {
 [txt] "zliimt"
 [type] 1
 [real_name] "谷新"
 [prefix] : "@"
 [sufffix] : ""
 [user_type] : "mention"
 }
 * 
 * @startPostion : default (0, 0) 
 * @fitWidth
 * @font
 * @heightReturn pointer type
 * @endPostion
 **/

// inner used
// @xxxxxxxxxxxxxxxxx > fitWidth
// tailTrancated
+ (NSArray *) parseAtNode:(NSDictionary *)node startPostion:(CGPoint)postion fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn endPostionReturn:(CGPoint*)endPostion 
{
    NSArray *token = [NSArray array];
    if (node == nil || maxFitWidth <= 0)
    {
        assert(false);
        return nil;
    }
    CGFloat posX = postion.x;
    CGFloat posY = postion.y;
        
    // face type
    if ([[node valueForKey:@"type"] intValue] == PLAT_PT_TYPE_AT)
    {
        NSString * prefix = [node valueForKey:@"prefix"];
        NSString * real_name = [node valueForKey:@"real_name"];
        NSString * suffix = [node valueForKey:@"suffix"];
        NSString * txt = [node valueForKey:@"txt"];    
                
        CGSize size = [[NSString stringWithFormat:@"%@%@%@", prefix, real_name, suffix] sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
        
        CGSize prefixSize = [prefix sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
        CGSize realNameSize = [real_name sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
        CGSize suffixSize = [suffix sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];    
        
        if (posX + size.width >= maxFitWidth)
        {
            posX = 0;
            posY += size.height;
            posY += LINE_SPACE;
            
            // more than one line, truncate
            prefixSize = [prefix sizeWithFont:font forWidth:maxFitWidth lineBreakMode:UILineBreakModeClip];   
        }
        
        NSDictionary * prefixFrame = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:posX], @"x",
                                      [NSNumber numberWithFloat:posY], @"y",
                                      [NSNumber numberWithFloat:prefixSize.width], @"w",
                                      [NSNumber numberWithFloat:prefixSize.height], @"h",
                                      nil];
        NSArray * frames = [NSArray arrayWithObject:prefixFrame];
        
        NSDictionary * realNameFrame = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:posX + prefixSize.width], @"x",
                                        [NSNumber numberWithFloat:posY], @"y",
                                        [NSNumber numberWithFloat:realNameSize.width], @"w",
                                        [NSNumber numberWithFloat:realNameSize.height], @"h",
                                        nil];
        frames = [frames arrayByAddingObject:realNameFrame];
        
        NSDictionary * suffixFrame = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:posX + prefixSize.width + realNameSize.width], @"x",
                                        [NSNumber numberWithFloat:posY], @"y",
                                        [NSNumber numberWithFloat:suffixSize.width], @"w",
                                        [NSNumber numberWithFloat:suffixSize.height], @"h",
                                        nil];
        frames = [frames arrayByAddingObject:suffixFrame];
        
        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              txt, @"txt", 
                              prefix, @"prefix",
                              suffix, @"suffix",
                              real_name, @"real_name",
                              [NSNumber numberWithInt:PLAT_PT_TYPE_AT], @"type",
                              frames, @"frames",
                              [NSNumber numberWithInt:COLOR_SCHEME_AT], @"color",
                              nil];
        token = [token arrayByAddingObject:dic];        
        [dic release];
        dic = nil;
        prefixFrame = nil;
        realNameFrame = nil;
        frames = nil;
        posX += size.width;
        
        CGPoint point = CGPointMake(posX, posY);    
        (*endPostion) = point;
        (*heightReturn) = posY + size.height;
    }
    
    return token;
}


/**
 * @token
 * @string source string  
 * @startPostion start from which to layout string
 * @maxFitWidth max with for string  
 * @font 
 * @heightReturn returned value
 * @endPostionReturn end postion 
 **/

/**
 *   node
 *   {
 *      [txt] 有图有真相
 *      [type] 0 
 *      [link] http://www.kaixin001.com/records/record.php
 *   }
 *      
 *   result
    {
        [type] 
        [linkArry]
        {
            [0] 
            [1]
            [2]    
        }
    }
 
    linkArry
    {
        [0] token 
        [1] token
        [2] token
        ...
    }
    
    token
    {
         [txt]
         [type]
         [prefix]
         [real_name]
         [frames]
    }
 **/
// mostly the same with pasreLinkNode

+ (NSArray *) parseLinkNodeFull:(NSDictionary *)node startPostion:(CGPoint)postion fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn endPostionReturn:(CGPoint*)endPostion 
{   
    NSArray * token = [NSArray array];
    NSArray * linkNodeArry = [[[NSArray alloc] init] autorelease];
    
    if (maxFitWidth < 0 || node == nil || linkNodeArry == nil)
    {
        assert(false);
        return nil;
    }
    
    // must be txt type 
    if ([[node valueForKey:@"type"] intValue] != PLAT_PT_TYPE_LINK)
    {
        assert(false);
        return nil;
    }
    
    NSString * subString = nil; 
    NSString * tmpString = nil;
    NSString * restString = [node valueForKey:@"txt"];
    
    CGRect subRect = CGRectMake(0, 0, 0, 0);    
    
    NSInteger i = 0;
    
    CGFloat x = postion.x;
    CGFloat y = postion.y;
    
    CGFloat fitwidth = maxFitWidth - x;
    
    while (restString != nil) 
    {
        tmpString = nil;
        subString = nil;
        
        // split restString 
        for ( i=1; i < [restString length] + 1; i++)
        {
            tmpString = [restString substringToIndex:i];
            CGSize size = [tmpString sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
            
            if (size.width > fitwidth)
            {
                break;
            }
            else
            {
                subString = tmpString;
                subRect.origin.x = x;
                subRect.origin.y = y;
                subRect.size.width = size.width;
                subRect.size.height = size.height;
            }
        }
        
        if (i == [restString length]) 
        {
            // 整个都放里边
            
            NSDictionary * coordinate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:subRect.origin.x], @"x",
                                         [NSNumber numberWithFloat:subRect.origin.y], @"y",
                                         [NSNumber numberWithFloat:subRect.size.width], @"w",
                                         [NSNumber numberWithFloat:subRect.size.height], @"h",
                                         nil];
            
            NSArray * frames = [NSArray arrayWithObject:coordinate];
            
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  restString, @"txt", 
                                  [NSNumber numberWithInt:PLAT_PT_TYPE_LINK ], @"type",
                                  frames, @"frames",
                                  [NSNumber numberWithInt:COLOR_SCHEME_LINK], @"color",
                                  nil];
            
            linkNodeArry = [linkNodeArry arrayByAddingObject:dic];
            
            [dic release];
            dic = nil;
            
            x += subRect.size.width;
        }        
        else if (subString != nil)
        {   
            
            NSDictionary * coordinate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:subRect.origin.x], @"x",
                                         [NSNumber numberWithFloat:subRect.origin.y], @"y",
                                         [NSNumber numberWithFloat:subRect.size.width], @"w",
                                         [NSNumber numberWithFloat:subRect.size.height], @"h",
                                         nil];
            
            NSArray * frames = [NSArray arrayWithObject:coordinate];
            
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  subString, @"txt", 
                                  [NSNumber numberWithInt:PLAT_PT_TYPE_LINK], @"type",
                                  frames, @"frames",
                                  [NSNumber numberWithInt:COLOR_SCHEME_LINK],@"color",
                                  nil];
            
            linkNodeArry = [linkNodeArry arrayByAddingObject:dic];
            
            [dic release];
            dic = nil;
            
            x += subRect.size.width;
        }   
        
        // split string 
        // 还有，继续切
        if (i < [restString length])
        {
            // 一个都放不了
            if (subString == nil)
            {
                // 换行
                x = 0;
                y += subRect.size.height;
                y += LINE_SPACE;
                fitwidth = maxFitWidth;
            }
            else
            {
                // 继续切
                restString = [restString substringFromIndex:i-1];
                fitwidth = fitwidth - subRect.size.width;
                
                // 放不下了
                if (fitwidth <= 0)
                {
                    x = 0;
                    y += subRect.size.height;
                    y += LINE_SPACE;
                    fitwidth = maxFitWidth;
                }
            }
        }
        else 
        {
            // finish
            restString = nil;
        }
        
    } //while (restString != nil) 
    
    (*heightReturn) = y + subRect.size.height;
    
    CGPoint pointReturn = CGPointMake(x, y);
    (*endPostion) = pointReturn;

    if (linkNodeArry != nil)
    {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:PLAT_PT_TYPE_LINK], @"type",
                              linkNodeArry, @"linkArry",
                              nil];
        token = [token arrayByAddingObject:dic];
    }
    return token;
}

+ (NSArray *) parseLinkNode:(NSDictionary *)node startPostion:(CGPoint)postion fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn endPostionReturn:(CGPoint*)endPostion 
{
    NSArray *token = [NSArray array];
    if (node == nil || maxFitWidth <= 0)
    {
        assert(false);
        return nil;
    }
    
    CGFloat posX = postion.x;
    CGFloat posY = postion.y;
        
    // face type
    if ([[node valueForKey:@"type"] intValue] == PLAT_PT_TYPE_LINK)
    {
        NSString * txt = [node valueForKey:@"txt"];
        NSString * link = [node valueForKey:@"link"];
        
        CGSize size = [txt sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip]; 
                        
        if (posX + size.width + LINK_ICON_WIDTH >= maxFitWidth)
        {
            posX = 0;
            posY += size.height;
            posY += LINE_SPACE;
            
            // more than one line, truncate
            size = [txt sizeWithFont:font forWidth:(maxFitWidth - LINK_ICON_WIDTH) lineBreakMode:UILineBreakModeClip];
        }
        
        NSDictionary * picFrame = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:posX], @"x",
                                   [NSNumber numberWithFloat:posY], @"y",
                                   [NSNumber numberWithFloat:LINK_ICON_WIDTH], @"w",
                                   [NSNumber numberWithFloat:LINK_ICON_HEIGHT], @"h",
                                   nil];
        NSArray * frames = [NSArray arrayWithObject:picFrame];
        
        NSDictionary * frame = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:posX + LINK_ICON_WIDTH], @"x",
                                      [NSNumber numberWithFloat:posY], @"y",
                                      [NSNumber numberWithFloat:size.width ], @"w",
                                      [NSNumber numberWithFloat:size.height], @"h",
                                      nil];
        frames = [frames arrayByAddingObject:frame];
        
        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              txt, @"txt", 
                              link, @"link",
                              [NSNumber numberWithInt:PLAT_PT_TYPE_LINK], @"type",
                              frames, @"frames",
                              [NSNumber numberWithInt:COLOR_SCHEME_LINK],@"color",
                              nil];
        token = [token arrayByAddingObject:dic];        
        [dic release];
        dic = nil;
        frame = nil;
        frames = nil;
        posX += size.width + LINK_ICON_WIDTH;
        
        CGPoint point = CGPointMake(posX, posY);    
        (*endPostion) = point;
        (*heightReturn) = posY + size.height;
    }
    
    return token;
}

+ (NSArray *) stringSplit:(NSString *)string fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn  
{
    NSArray *token = [NSArray array];

    CGPoint point = CGPointMake(0, 0);
    CGPoint target = CGPointMake(0, 0);
    
    return [NodeParser stringSplit:token string:string startPostion:point fitWidth:maxFitWidth font:font heightReturn:heightReturn endPostionReturn:&target];
}


/**
 * @token
 * @string source string  
 * @startPostion start from which to layout string
 * @maxFitWidth max with for string  
 * @font 
 * @heightReturn returned value
 * @endPostionReturn end postion 
 **/

+ (NSArray *) stringSplit:(NSString *)string startPostion:(CGPoint)postion fitWidth:(CGFloat)maxFitWidth font:(UIFont*)font heightReturn:(CGFloat*) heightReturn endPostionReturn:(CGPoint*)endPostion 
{   
    NSArray *token = [NSArray array];
    if (maxFitWidth < 0 || string == nil)
    {
        assert(false);
        return nil;
    }
    
    NSString * subString = nil; 
    NSString * tmpString = nil;
    NSString * restString = string;
    
    CGRect subRect = CGRectMake(0, 0, 0, 0);    
    
    NSInteger i = 0;
    
    CGFloat x = postion.x;
    CGFloat y = postion.y;
    
    CGFloat fitwidth = maxFitWidth - x;
    
    while (restString != nil) 
    {
        tmpString = nil;
        subString = nil;
        
        // split restString 
        for ( i=1; i < [restString length] + 1; i++)
        {
            tmpString = [restString substringToIndex:i];
            CGSize size = [tmpString sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:UILineBreakModeClip];        
            
            if (size.width > fitwidth)
            {
                break;
            }
            else
            {
                subString = tmpString;
                subRect.origin.x = x;
                subRect.origin.y = y;
                subRect.size.width = size.width;
                subRect.size.height = size.height;
            }
        }
        
        if (i == [restString length]) 
        {
            // 整个放里边
            NSDictionary * coordinate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:subRect.origin.x], @"x",
                                         [NSNumber numberWithFloat:subRect.origin.y], @"y",
                                         [NSNumber numberWithFloat:subRect.size.width], @"w",
                                         [NSNumber numberWithFloat:subRect.size.height], @"h",
                                         nil];
            NSArray * frames = [NSArray arrayWithObject:coordinate];
            
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  restString, @"txt", 
                                  frames, @"frames",
                                  [NSNumber numberWithInt:COLOR_SCHEME_DEFAULT],@"color",
                                  nil];
            
            token = [token arrayByAddingObject:dic];
            
            [dic release];
            dic = nil;
            coordinate = nil;
            frames = nil;
            x += subRect.size.width;
        }        
        else if (subString != nil)
        {           
            
            NSDictionary * coordinate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:subRect.origin.x], @"x",
                                         [NSNumber numberWithFloat:subRect.origin.y], @"y",
                                         [NSNumber numberWithFloat:subRect.size.width], @"w",
                                         [NSNumber numberWithFloat:subRect.size.height], @"h",
                                         nil];
            NSArray * frames = [NSArray arrayWithObject:coordinate];
            
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  subString, @"txt", 
                                  frames, @"frames",
                                  [NSNumber numberWithInt:COLOR_SCHEME_DEFAULT],@"color",
                                  nil];
            
            token = [token arrayByAddingObject:dic];
            
            [dic release];
            dic = nil;
            
            x += subRect.size.width;
        }   
        
        // split string 
        // 还有，继续切
        if (i < [restString length])
        {
            // 一个都放不了
            if (subString == nil)
            {
                // 换行
                x = 0;
                y += subRect.size.height;
                y += LINE_SPACE;
                fitwidth = maxFitWidth;
            }
            else
            {
                // 继续切
                restString = [restString substringFromIndex:i-1];
                fitwidth = fitwidth - subRect.size.width;
                
                // 放不下了
                if (fitwidth <= 0)
                {
                    x = 0;
                    y += subRect.size.height;
                    y += LINE_SPACE;
                    fitwidth = maxFitWidth;
                }
            }
        }
        else 
        {
            // finish
            restString = nil;
        }
        
    } //while (restString != nil) 
    
    (*heightReturn) = y + subRect.size.height;
    
    CGPoint pointReturn = CGPointMake(x, y);
    (*endPostion) = pointReturn;
    NSLog(@" sub : %@", token);  
    return token;
}


@end
