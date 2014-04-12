//
//  LinkView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "LinkView.h"

@implementation LinkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithLink:(Link*)link
{
    self.link = link;
    [self formatDisplay];
    return self;
}

-(void) formatDisplay
{
    UILabel *label;
    label.text = self.link.label;
    UILabel *link;
    link.text = self.link.url;
    [self addSubview:label];
    [self addSubview:link];
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
