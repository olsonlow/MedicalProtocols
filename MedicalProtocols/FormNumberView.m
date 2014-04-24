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
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame andFormNumber:(FormNumber *)formNumber
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor purpleColor];
    UISlider *slider= [[UISlider alloc]init];
    slider.frame = CGRectMake(frame.origin.x, frame.origin.y, 200, 50);
    [slider setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    slider.maximumValue = formNumber.maxValue;
    slider.minimumValue = formNumber.minValue;
    slider.value = formNumber.defaultValue;
    
    UILabel *sliderLabel = [[UILabel alloc]init];
    CGSize stringSize = [formNumber.label sizeWithAttributes:@{NSFontAttributeName:sliderLabel.font}];
    sliderLabel.text = formNumber.label;
    sliderLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height);
    [sliderLabel setCenter:CGPointMake(slider.frame.origin.x+100, sliderLabel.frame.origin.y-10)];
    [self addSubview:sliderLabel];
    [self addSubview:slider];
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
