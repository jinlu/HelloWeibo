//
//  NodeFactory.h
//  SinaWeiboXAuthDemo
//
//  Created by Shi Jin Lu on 12-1-2.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodeLib : NSObject

+ (NSDictionary *)textNode:(NSString *)text;
+ (NSDictionary *)faceNode:(NSString *)faceText;
+ (NSDictionary *)AtNode:(NSString *)txt 
                realName:(NSString *)realName 
                  prefix:(NSString *)prefix;
+ (NSDictionary *)linkNode:(NSString *)url;
+ (NSArray *)generateDemoNodes;
+ (NSArray *)generateTextNodes:(NSString *)text;


@end
