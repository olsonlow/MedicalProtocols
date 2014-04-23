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
    self.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    UILabel *title = [[UILabel alloc]init];
    CGSize titleStringSize = [self.textBlock.title sizeWithAttributes:@{NSFontAttributeName:title.font}];
    title.frame = CGRectMake(frame.origin.x, frame.origin.y, titleStringSize.width, titleStringSize.height);
    title.text = self.textBlock.title;
    
    UILabel *content = [[UILabel alloc]init];
    CGSize contentStringSize = [self.textBlock.content sizeWithAttributes:@{NSFontAttributeName:content.font}];
    content.frame = CGRectMake(frame.origin.x, frame.origin.y, contentStringSize.width, contentStringSize.height);
    content.text = self.textBlock.content;
    content.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    [self addSubview:title];
    [self addSubview:content];
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

@end
