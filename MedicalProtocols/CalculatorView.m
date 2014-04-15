//
//  CalculatorView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "CalculatorView.h"

@implementation CalculatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect) frame andCalculator:(Calculator *) calculator
{
    self = [super initWithFrame:frame];
    self.calculator = calculator;
    self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:205.0/255.0 blue:193.0/255.0 alpha:1.0];
   
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    name.center = CGPointMake(name.frame.size.height/2, name.frame.size.width/4);
    name.text = @"Calculator";
    
    UILabel *calcId = [[UILabel alloc]init];
    calcId.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    [calcId setCenter:self.center];
    calcId.text = self.calculator.objectId;
    
    [self addSubview:calcId];
    [self addSubview:name];
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
