//
//  FormNumberView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormNumberView.h"
#import "Form.h"
#import "FormNumber.h"
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

    self.backgroundColor = [UIColor purpleColor];
    self.slider = [[UISlider alloc]init];
    self.sliderLabel = [[UILabel alloc]init];
    self.formNumber = formNumber;
    self.formNumber.valueSet = NO;
    self.slider.frame = CGRectMake(frame.origin.x, frame.origin.y, 200, 20);
    [self.slider setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    self.slider.maximumValue = self.formNumber.maxValue;
    self.slider.minimumValue = self.formNumber.minValue;
    self.slider.value = self.formNumber.defaultValue;
    
    NSString *labelText = [NSString stringWithFormat:@"%@: %d",self.formNumber.label,(int)self.slider.value];
    self.sliderLabel.text = labelText;
    CGSize stringSize = [labelText sizeWithAttributes:@{NSFontAttributeName:self.sliderLabel.font}];
    self.sliderLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height);
    [self.sliderLabel setCenter:CGPointMake(self.slider.frame.origin.x+100, self.sliderLabel.frame.origin.y-10)];
    
    //in here, we must get the value that the user entered and pass that back to the Form to store in an array, which later will be passed to formAlgorithm to compute
    [self addSubview:self.sliderLabel];
    [self addSubview:self.slider];
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    return self;
}

- (IBAction)sliderChanged:(UISlider *)sender
{
    NSString *labelText = [NSString stringWithFormat:@"%@: %d",self.formNumber.label,(int)self.slider.value];
    CGSize stringSize = [labelText sizeWithAttributes:@{NSFontAttributeName:self.sliderLabel.font}];
    self.sliderLabel.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, stringSize.width, stringSize.height);
    [self.sliderLabel setCenter:CGPointMake(self.slider.frame.origin.x+100, self.sliderLabel.frame.origin.y-10)];
    self.sliderLabel.text = labelText;
    self.formNumber.valueSet = YES;
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
