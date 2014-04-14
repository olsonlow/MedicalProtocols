//
//  TextBlockView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "TextBlockView.h"
#import "TextBlock.h"
@implementation TextBlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame: (CGRect)frame textBlock:(TextBlock*)textBlock
{
    self = [super initWithFrame:frame];
    
    self.textBlock = textBlock;
    self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.backgroundColor = [UIColor redColor];
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    title.center = CGPointMake(title.frame.size.height/2, title.frame.size.width/4);
    title.text = self.textBlock.title;
    NSLog(@"TITLE: %@", title.text);
    UILabel *content = [[UILabel alloc]init];
    content.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    content.text = self.textBlock.content;
    content.center = CGPointMake(frame.size.height/2, frame.size.width/4);
    [self addSubview:title];
    [self addSubview:content];
    [self bringSubviewToFront:self];
    return self;
}

-(void) formatDisplay
{
     //self.backgroundColor = [UIColor colorWithRed:240.0 green:234.0 blue:214.0 alpha:1.0];
    self.backgroundColor = [UIColor redColor];
    NSLog(@"TITLE: %@", self.textBlock.title);
    UILabel *title;
    title.text = self.textBlock.title;
    UILabel *content;
    content.text = self.textBlock.content;
    content.hidden = NO;
    title.hidden = NO;
  //  title.center = CGPointMake(, <#CGFloat y#>)
    [self addSubview:title];
    [self addSubview:content];
    [self bringSubviewToFront:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
