//
//  ComponentView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "TextBlockView.h"
#import "FormView.h"
#import "LinkView.h"
#import "CalculatorView.h"
@implementation ComponentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame Object:(id)object
{
    //set up background here...
    
    [self addSubview:[ComponentView componentWithFrame:frame Object:object]];
    return self;
}

+(ComponentView *)componentWithFrame:(CGRect)frame Object:(id)object
{
    ComponentView * result;
    if([object isKindOfClass:[Form class]])
    {
        //create and add a form view
        result = [[FormView alloc]initWithForm:object];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        //create and add a text block view
        result = [[TextBlockView alloc]initWithTextBlock:object];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        //create and add a calculator view
        result = [[CalculatorView alloc]initWithCalculator:object];
    }
    else if([object isKindOfClass:[Link class]])
    {
        //create and add a link view
        result = [[LinkView alloc] initWithLink:object];
    }
    return result;
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
