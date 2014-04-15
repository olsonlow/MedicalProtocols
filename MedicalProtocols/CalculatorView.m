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
    NSLog(@"CALCULATOR OBJECT");
    self.calculator = calculator;
    self.backgroundColor = [UIColor colorWithRed:251.0 green:206.0 blue:177.0 alpha:1.0];
    UILabel *calcId = [[UILabel alloc]init];
    calcId.text = self.calculator.objectId;
    calcId.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    calcId.center = CGPointMake(frame.size.height/2, frame.size.width/4);
    [self addSubview:calcId];
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
