//
//  FormNumberView.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson, Zach Dahlgren, and Lowell Olson on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormNumberView.h"
#import "Form.h"
#import "FormNumber.h"
#import <QuartzCore/QuartzCore.h>

@implementation FormNumberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialization code...
        self.frame  = frame;
        self.slider = [[UISlider alloc]init];
        self.sliderLabel =  [[UILabel alloc]init];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame andFormNumber:(FormNumber *)formNumber
{
    self = [super initWithFrame:frame];
    self.frame = frame;

    self.backgroundColor = [UIColor whiteColor];
    self.slider = [[UISlider alloc]init];
    self.sliderLabel = [[UILabel alloc]init];
    [self addUpperBorder];
    self.formNumber = formNumber;
    self.formNumber.valueSet = NO;
    self.slider.frame = CGRectMake(frame.origin.x, frame.origin.y, 200, 10);
    [self.slider setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    self.slider.maximumValue = self.formNumber.maxValue;
    self.slider.minimumValue = self.formNumber.minValue;
    self.slider.value = self.formNumber.defaultValue;
    
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    NSString *labelText = [NSString stringWithFormat:@"%@: Please slide to value",self.formNumber.label];
    self.sliderLabel.text = labelText;
    CGSize stringSize = [labelText sizeWithAttributes:@{NSFontAttributeName:self.sliderLabel.font}];
    
    self.sliderLabel.frame = CGRectMake(self.slider.frame.origin.x, self.slider.frame.origin.y-20, stringSize.width, stringSize.height);
    [self.sliderLabel setCenter:CGPointMake(self.slider.frame.origin.x+100, self.slider.frame.origin.y-40)];
    //in here, we must get the value that the user entered and pass that back to the Form to store in an array, which later will be passed to formAlgorithm to compute
    [self addSubview:self.sliderLabel];
    [self addSubview:self.slider];
    
    return self;
}
- (IBAction)sliderChanged:(UISlider *)sender
{
    NSString *labelText = [NSString stringWithFormat:@"%@: %d",self.formNumber.label,(int)self.slider.value];
    self.sliderLabel.text = labelText;
    self.formNumber.valueSet = YES;
}

- (void)addUpperBorder
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor whiteColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.0f);
    [self.layer addSublayer:upperBorder];
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
