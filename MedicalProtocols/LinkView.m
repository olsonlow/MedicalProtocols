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

-(id)initWithFrame:(CGRect)frame andLink:(Link*)link
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blueColor];
    NSLog(@"LINK OBJECT: %@", link.url);
    self.link = link;
    self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //linkButton.center = CGPointMake(frame.size.height/2, frame.size.width/4);
    [linkButton setCenter:self.center];
    linkButton.backgroundColor = [UIColor yellowColor];
    [linkButton setFrame:CGRectMake(frame.origin.x, frame.origin.y, 100, 100)];
    [linkButton setTitle:self.link.url forState:UIControlStateNormal];
    //[linkButton setFont:[UIFont boldSystemFontOfSize:20]];
   // [linkButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    UILabel *l = [[UILabel alloc]init];
    [l setCenter:self.center];
    [l setFrame:CGRectMake(frame.origin.x, frame.origin.y, 100, 100)];
    l.text = @"HELLO";
    [self addSubview:l];
    [self addSubview:linkButton];
    [self bringSubviewToFront:self];
    
    
    
    
//    self.backgroundColor = [UIColor colorWithRed:194.0 green:194.0 blue:194.0 alpha:1.0];
//    self.backgroundColor = [UIColor blueColor];
//    UILabel *label = [[UILabel alloc]init];
//    label.text = self.link.label;
//    UILabel *linkLabel = [[UILabel alloc]init];
//    linkLabel.text = self.link.url;
//    CGPoint labelCenter = CGPointMake(self.center.x/2, self.center.y/2);
//    CGPoint linkCenter = CGPointMake(self.center.x/4, self.center.y/4);
//    [label setCenter:labelCenter];
//    [linkLabel setCenter:linkCenter];
//    [self addSubview:label];
//    [self addSubview:linkLabel];
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
