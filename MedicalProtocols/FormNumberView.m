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

    self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:190.0/255.0 blue:230.0 alpha:1];
    UISlider *slider= [[UISlider alloc]init];
    slider.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    [slider setCenter:self.center];
    slider.maximumValue = formNumber.maxValue;
    slider.minimumValue = formNumber.minValue;
    slider.value = formNumber.defaultValue;
    
    NSLog(@"LABEL: %@", formNumber.label);
    UILabel *sliderLabel = [[UILabel alloc]init];
    [sliderLabel setCenter:CGPointMake(frame.size.width/4, frame.size.width/4)];
    //sliderLabel.frame = CGRectMake(frame.origin.x-20, frame.origin.y-20, 50, 50);
    sliderLabel.text = formNumber.label;
    
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
