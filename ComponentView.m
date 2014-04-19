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
    self.backgroundColor = [UIColor clearColor];
    ComponentView * componentView = [ComponentView componentWithFrame:CGRectMake(padding, padding, self.frame.size.width +(2*padding), self.frame.size.height+(2*padding)) Object:object];
    componentView.frame = CGRectMake(padding, padding, self.frame.size.width +(2*padding), self.frame.size.height+(2*padding));
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

- (void)startWobble {
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = 0.6;
    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.alpha = 0.8;
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-2));
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
                     }
                     completion:NULL
     ];
}

- (void)stopWobble {
    self.layer.shouldRasterize = NO;
    self.layer.rasterizationScale = 1;
    self.alpha = 1;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL
     ];
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
