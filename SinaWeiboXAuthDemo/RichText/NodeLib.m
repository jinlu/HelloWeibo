//
//  NodeFactory.m
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-1-2.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import "NodeLib.h"
#import "NodeParser.h"

@implementation NodeLib

+ (NSDictionary *)textNode:(NSString *)text
{
    NSDictionary * node = [NSDictionary dictionaryWithObjectsAndKeys:text, @"txt",[NSNumber numberWithInt:PLAT_PT_TYPE_TEXT], @"type", nil];    
    
    return node;
}

/*
 * @faceText @"(开心)"
 */
+ (NSDictionary *)faceNode:(NSString *)faceText
{
    NSDictionary * node = [NSDictionary dictionaryWithObjectsAndKeys:faceText, @"txt", 
                           [NSNumber numberWithInt:PLAT_PT_TYPE_ICON], @"type", nil];
    return node;
}

+ (NSDictionary *)AtNode:(NSString *)txt realName:(NSString *)realName prefix:(NSString *)prefix
{
    NSDictionary * node = [NSDictionary dictionaryWithObjectsAndKeys:txt, @"txt",
                           [NSNumber numberWithInt:PLAT_PT_TYPE_AT], @"type", 
                           realName, @"real_name", 
                           prefix, @"prefix", nil];  
    return node;
}


+ (NSDictionary *)linkNode:(NSString *)url
{
    NSDictionary * node = [NSDictionary dictionaryWithObjectsAndKeys: 
                           @"附链接", @"txt", 
                           url, @"link",
                           [NSNumber numberWithInt:PLAT_PT_TYPE_LINK], @"type", nil];
    return node;    
}

+ (NSArray *)generateDemoNodes
{    
    NSArray *nodes = [NSArray array];    
    NSString * stringA = @"香港东方日报评论摘录：abcdefaafads北大以产富豪为荣，清华以出政要自豪，作为中国最顶尖的两所大学，不以学术较长短，却以媚俗惊世人，中国教育又有何希望？中国社会核心价值观又怎能不崩溃？大学之伤，是社会之痛，大学作为社会良心最后底线失守，意味着中国社会进入一切向钱看、一切向权看的时代";    
    NSString * stringB = @"\t一位教授演讲时拿出20美元，他问学生谁要这20美元，台下的人纷纷举手。教授将钱扔到地上用脚碾过，又问谁要，台下依旧有人举手。教授说：“我如此对待这张钱币，你们依旧想要，这是因为它没有因为我的践踏而贬值，人生亦是如此。人生的价值不在于他人的赞赏或批评，而是取决于我们自身";
    
    NSDictionary * nodeStringA = [NodeLib textNode:stringA];
    nodes = [nodes arrayByAddingObject:nodeStringA];
    
    NSDictionary * nodeFace = [NodeLib faceNode:@"(开心)"]; 
    nodes = [nodes arrayByAddingObject:nodeFace];
    
    NSDictionary * nodeAt = [NodeLib AtNode:@"zliimt" realName:@"谷新" prefix:@"@"]; 
    nodes = [nodes arrayByAddingObject:nodeAt];   
    
    NSString * stringC = @"http://www.diandian.com/tag/%E7%BE%8E%E5%A5%B3/feed";    
    NSDictionary * nodeLink = [NodeLib linkNode:stringC];
    nodes = [nodes arrayByAddingObject:nodeLink]; 
    
    NSDictionary * nodeStringB = [NodeLib textNode:stringB];
    nodes = [nodes arrayByAddingObject:nodeStringB];
    return nodes;
}

@end
