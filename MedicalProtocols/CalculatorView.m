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

-(id) initWithCalculator:(Calculator *) calculator
{
    self.calculator = calculator;
    [self formatDisplay];
    return self;
}

-(void) formatDisplay
{
     self.backgroundColor = [UIColor colorWithRed:251.0 green:206.0 blue:177.0 alpha:1.0];
    UILabel *calcId;
    calcId.text = self.calculator.objectId;
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
