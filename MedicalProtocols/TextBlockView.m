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
    [self formatDisplay];
    return self;
}

-(void) formatDisplay
{
     self.backgroundColor = [UIColor colorWithRed:240.0 green:234.0 blue:214.0 alpha:1.0];
    UILabel *title;
    title.text = self.textBlock.title;
    UILabel *content;
    content.text = self.textBlock.content;
    [self addSubview:title];
    [self addSubview:content];
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
