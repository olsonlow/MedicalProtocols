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

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
@implementation ComponentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setDataObject:(id)dataObject{
    if(!_dataObject){
        [self setupViewWithObject:dataObject];
    }
}
-(id) initWithFrame:(CGRect)frame Object:(id)object
{
    //set up background here...
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewWithObject:object];
    }
    return self;
}
-(void)setupViewWithObject:(id)object{
    float padding = 10.0;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor grayColor];
    ComponentView * componentView = [ComponentView componentWithFrame:CGRectMake(padding, padding, self.frame.size.width-(2*padding), self.frame.size.height-(2*padding)) Object:object];;
    [self addSubview:componentView];
}
+(ComponentView *)componentWithFrame:(CGRect)frame Object:(id)object
{
    ComponentView * result;
    if([object isKindOfClass:[Form class]])
    {
        //create and add a form view
        NSLog(@"COMPONENT IS A FORM");
        result = [[FormView alloc]initWithFrame: frame andForm:object];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        //create and add a text block view
        result = [[TextBlockView alloc]initWithFrame:frame textBlock:object];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        //create and add a calculator view
        result = [[CalculatorView alloc]initWithFrame: frame andCalculator:object];
    }
    else if([object isKindOfClass:[Link class]])
    {
        //create and add a link view
        result = [[LinkView alloc] initWithFrame: frame andLink:object];
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
