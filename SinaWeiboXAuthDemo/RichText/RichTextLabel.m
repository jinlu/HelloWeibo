//
//  TestSubView.m
//  test_client 
//
//  Created by JinLu on 11-6-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RichTextLabel.h"
#import "NodeParser.h"
#import "NodeFactory.h"

@interface RichTextLabel (private)
- (void) createRichLabel:(HTOKENARRY)tokens font:(UIFont*)font totoalHeight:(CGFloat)totalHeight;
@end

@implementation RichTextLabel

- (HTOKENARRY)nodeToToken:(NSArray*)nodes font:(UIFont*)sysFont heightReturn:(CGFloat*)heightReturn 
               startPoint:(CGPoint)startPoint endPointReturn:(CGPoint*) endPointReturn
{
    CGFloat totalHeight = 0;
    
    assert(nodes != nil && sysFont != nil && [nodes isKindOfClass:[NSArray class]]);
    
    if ([nodes isKindOfClass:[NSArray class]] && [nodes count] > 0 && sysFont != nil)
    {   
        NSArray * tokenArray = [[[NSArray alloc] init] autorelease];
        NSArray * token;
        CGPoint endPoint = CGPointMake(0, 0);
        
        id node;
        
        for (node in nodes)
        {
            int type = [[node valueForKey:@"type"] intValue];
            
            switch (type) 
            {
                case PLAT_PT_TYPE_TEXT: 
                    token = [NodeParser parseStringNode:node startPostion:startPoint fitWidth:self.frame.size.width font:sysFont heightReturn:&totalHeight endPostionReturn:&endPoint];
                    tokenArray = [tokenArray arrayByAddingObjectsFromArray:token];
                    break;
                case PLAT_PT_TYPE_AT: 
                    token = [NodeParser parseAtNode:node startPostion:startPoint fitWidth:self.frame.size.width font:sysFont heightReturn:&totalHeight endPostionReturn:&endPoint];
                    tokenArray = [tokenArray arrayByAddingObjectsFromArray:token];                    
                    break;
                case PLAT_PT_TYPE_TOPIC:
                    
                    break;
                case PLAT_PT_TYPE_LINK:
                    token = [NodeParser parseLinkNode:node startPostion:startPoint fitWidth:self.frame.size.width font:sysFont heightReturn:&totalHeight endPostionReturn:&endPoint];
                    tokenArray = [tokenArray arrayByAddingObjectsFromArray:token];                    
                    break;
                case PLAT_PT_TYPE_ICON:
                    token = [NodeParser parseFaceNode:node startPostion:startPoint fitWidth:self.frame.size.width font:sysFont heightReturn:&totalHeight endPostionReturn:&endPoint];
                    tokenArray = [tokenArray arrayByAddingObjectsFromArray:token];                    
                    break;
                default:
                    break;
            }
            
            startPoint = endPoint;
        } //for (node in nodes)
        
        if (heightReturn != nil)
            (*heightReturn) = totalHeight;
        
        if (endPointReturn != nil)
            (*endPointReturn) = endPoint;
        
        return tokenArray;
    }
    
    return nil;
}

- (void)richTextSetInfo:(NSArray *)nodes
{    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPontReturn = CGPointMake(0, 0);

    [self richTextSetInfo:nodes startPoint:startPoint endPointReturn:&endPontReturn];
}

- (void)richTextSetInfo:(NSArray *)nodes startPoint:(CGPoint)startPoint endPointReturn:(CGPoint*)endPointReturn
{    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    UIFont * sysFont =  [UIFont systemFontOfSize:SYSTEM_FONT_SIZE];
    CGFloat totalHeight = 0;

    assert(endPointReturn != nil);
    if (endPointReturn != nil)
    {
        HTOKENARRY tokens = [self nodeToToken:nodes font:sysFont heightReturn:&totalHeight startPoint:startPoint endPointReturn:endPointReturn];

        [self createRichLabel:tokens font:sysFont totoalHeight:totalHeight];
    }
    
    [pool release];
}

- (void)richTextSetDemoInfo
{
    NSArray *nodes = [NodeFactory generateDemoNodes];
    [self richTextSetInfo:nodes];
}

- (void)createRichLabel:(HTOKENARRY)tokens font:(UIFont*)sysFont totoalHeight:(CGFloat)totalHeight
{
    if (tokens == nil || sysFont == nil )
    {
        assert(FALSE);
        return;
    }
    
    for (UIView * view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    // generate mutli label for text, and UIImage for face  
    id dic = nil;
    
    for (dic in tokens)
    {
        if ([dic isKindOfClass:[NSDictionary class]]) 
        {                                    
            NSInteger type = [[dic valueForKey:@"type"] intValue];
            
            if (type == PLAT_PT_TYPE_TEXT)
            {
                NSArray * frames = [dic valueForKey:@"frames"];
                
                if (frames != nil && [frames count] > 0 )
                {
                    NSDictionary* coordinate = [frames objectAtIndex:0];
                    
                    CGFloat x = [[coordinate valueForKey:@"x"] floatValue];
                    CGFloat y = [[coordinate valueForKey:@"y"] floatValue];
                    CGFloat w = [[coordinate valueForKey:@"w"] floatValue];
                    CGFloat h = [[coordinate valueForKey:@"h"] floatValue];
                    
                    NSString * text = [dic valueForKey:@"txt"];
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
                    // must be exctly the same with sprintSplit font 
                    label.font = sysFont;
                    [label setBackgroundColor:[UIColor clearColor]];
                    // set clip mode to avoid ... be showed 
                    [label setLineBreakMode:UILineBreakModeClip];
                    [label setText:text];
                    [self addSubview:label];
                    [label release];                    
                }
            }
            else if (type == PLAT_PT_TYPE_ICON)
            {
                NSArray * frames = [dic valueForKey:@"frames"];
                
                if (frames != nil && [frames count] > 0 )
                {
                    NSDictionary* coordinate = [frames objectAtIndex:0];
                    
                    CGFloat x = [[coordinate valueForKey:@"x"] floatValue];
                    CGFloat y = [[coordinate valueForKey:@"y"] floatValue];
                    CGFloat w = [[coordinate valueForKey:@"w"] floatValue];
                    CGFloat h = [[coordinate valueForKey:@"h"] floatValue];
                    
                    NSString * text = [dic valueForKey:@"txt"];
                    
                    int index = 0;
                    for (int i=0; i < FACE_COUNT; i++)
                    {
                        if ([text compare:arryFace[i]] == 0)
                        {
                            index = i;
                        }
                    }
                    
                    NSString * name = nil;
                    if (index < FACE_COUNT)
                    {
                        name = [NSString stringWithFormat:@"%@.png", [NSNumber numberWithInt:index + 97]];
                    }
                    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                    [imageView setBackgroundColor:[UIColor clearColor]];
                    [imageView setImage:[UIImage imageNamed:name]];
                    [self addSubview:imageView];
                    [imageView release];
                }
            }
            else if (type == PLAT_PT_TYPE_AT)
            {                
                NSArray * frames = [dic valueForKey:@"frames"];
                
                if (frames != nil && [frames count] >= 3 )
                {
                    CGFloat x1=0,y1=0,w1=0,h1=0;
                    CGFloat x2=0,y2=0,w2=0,h2=0;
                    CGFloat x3=0,y3=0,w3=0,h3=0;
                    
                    NSDictionary* prefixFrame = [frames objectAtIndex:0];
                    NSDictionary* realNameFrame = [frames objectAtIndex:1];
                    NSDictionary* suffixFrame = [frames objectAtIndex:2];
                    // prefix
                    x1 = [[prefixFrame valueForKey:@"x"] floatValue];
                    y1 = [[prefixFrame valueForKey:@"y"] floatValue];
                    w1 = [[prefixFrame valueForKey:@"w"] floatValue];
                    h1 = [[prefixFrame valueForKey:@"h"] floatValue];
                    
                    // real name
                    x2 = [[realNameFrame valueForKey:@"x"] floatValue];
                    y2 = [[realNameFrame valueForKey:@"y"] floatValue];
                    w2 = [[realNameFrame valueForKey:@"w"] floatValue];
                    h2 = [[realNameFrame valueForKey:@"h"] floatValue];
                    
                    // suffix
                    x3 = [[suffixFrame valueForKey:@"x"] floatValue];
                    y3 = [[suffixFrame valueForKey:@"y"] floatValue];
                    w3 = [[suffixFrame valueForKey:@"w"] floatValue];
                    h3 = [[suffixFrame valueForKey:@"h"] floatValue];
                    
                    NSString * prefix = [dic valueForKey:@"prefix"];
                    NSString * real_name = [dic valueForKey:@"real_name"];
                    NSString * suffix = [dic valueForKey:@"suffix"];
                    NSString * uname = [dic valueForKey:@"txt"];
                    ActionLabel * label1 = [[ActionLabel alloc] initWithFrame:CGRectMake(x1, y1, w1, h1)];
                    // must be exctly the same with parseXXX font 
                    label1.font = sysFont;
                    [label1 setText:prefix];
                    [label1 setDelegate:self];
                    if ([uname length] > 0)
                        [label1 setAttachData:[NSDictionary dictionaryWithObjectsAndKeys:
                                               uname, @"uname",
                                               real_name, @"real_name", 
                                               nil
                                               ]];
                    [label1 setBackgroundColor:[UIColor clearColor]];
                    [self addSubview:label1];
                    [label1 release];
                    
                    ActionLabel * label2 = [[ActionLabel alloc] initWithFrame:CGRectMake(x2, y2, w2, h2)];
                    // must be exctly the same with parseXXX font 
                    label2.font = sysFont;
                    [label2 setText:real_name];
                    [label2 setDelegate:self];
                    if ([uname length] > 0)
                        [label2 setAttachData:[NSDictionary dictionaryWithObjectsAndKeys:
                                               uname, @"uname",
                                               real_name, @"real_name", 
                                               nil
                                               ]];
                    [label2 setBackgroundColor:[UIColor clearColor]];
                    [self addSubview:label2];
                    [label2 release];
                    
                    ActionLabel * label3 = [[ActionLabel alloc] initWithFrame:CGRectMake(x3, y3, w3, h3)];
                    // must be exctly the same with parseXXX font 
                    label3.font = sysFont;
                    [label3 setText:suffix];
                    [label3 setDelegate:self];
                    if ([uname length] > 0)
                        [label3 setAttachData:[NSDictionary dictionaryWithObjectsAndKeys:
                                               uname, @"uname",
                                               real_name, @"real_name", 
                                               nil
                                               ]];
                    [label3 setBackgroundColor:[UIColor clearColor]];
                    [self addSubview:label3];
                    [label3 release];
                    
                    int colorScheme = [[dic valueForKey:@"color"] intValue];
                    if (colorScheme == COLOR_SCHEME_AT)
                    {
                        [label1 setTextColor:[UIColor grayColor]];
                        [label2 setTextColor:COLOR_AT];
                        [label3 setTextColor:COLOR_AT];
                    }                    
                }
            } // At
            else if (type == PLAT_PT_TYPE_LINK)
            {
                NSArray * frames = [dic valueForKey:@"frames"];
                
                if (frames != nil && [frames count] >= 2 )
                {
                    CGFloat x1=0,y1=0,w1=0,h1=0;
                    CGFloat x2=0,y2=0,w2=0,h2=0;
                    
                    NSDictionary* prefixFrame = [frames objectAtIndex:0];
                    NSDictionary* realNameFrame = [frames objectAtIndex:1];
                    
                    x1 = [[prefixFrame valueForKey:@"x"] floatValue];
                    y1 = [[prefixFrame valueForKey:@"y"] floatValue];
                    w1 = [[prefixFrame valueForKey:@"w"] floatValue];
                    h1 = [[prefixFrame valueForKey:@"h"] floatValue];
                    
                    x2 = [[realNameFrame valueForKey:@"x"] floatValue];
                    y2 = [[realNameFrame valueForKey:@"y"] floatValue];
                    w2 = [[realNameFrame valueForKey:@"w"] floatValue];
                    h2 = [[realNameFrame valueForKey:@"h"] floatValue];
                    
                    NSString * txt = [dic valueForKey:@"txt"];
                    NSString * link = [dic valueForKey:@"link"];
                    
                    // hard coded , it's bad 
                    UIImageView * linkImage = [[UIImageView alloc] initWithFrame:CGRectMake(x1, y1 + 5, w1, h1)];
                    [linkImage setImage:[UIImage imageNamed:@"linkicon"]];
                    [self addSubview:linkImage];
                    [linkImage release];
                    
                    ActionLabel * label = [[ActionLabel alloc] initWithFrame:CGRectMake(x2, y2, w2, h2)];
                    // must be exctly the same with parseXXX font 
                    label.font = sysFont;
                    [label setText:txt];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setDelegate:self];
                    [label setAttachData:[NSDictionary dictionaryWithObject:link forKey:@"link"]];    
                    [self addSubview:label];
                    [label release];
                    
                    int colorScheme = [[dic valueForKey:@"color"] intValue];
                    if (colorScheme == COLOR_SCHEME_LINK)
                    {
                        [label setTextColor:COLOR_AT];
                    }                    
                }
            }   
        }
    }
        
    // set height 
    CGRect frame = self.frame;
    frame.size.height = totalHeight;
    self.frame = frame;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

- (void)actionLabel:(ActionLabel *)actionLabel attachData:(NSDictionary *)data
{
    NSString * url = [data valueForKey:@"link"];
    if (url != nil)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
