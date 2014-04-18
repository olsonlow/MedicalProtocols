//
//  FormSelectionView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormSelectionView.h"
#import "FormSelection.h"
#import "RadioButton.h"
@implementation FormSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame andFormSelection:(FormSelection *)formSelection
{
    self = [super initWithFrame:frame];
    NSLog(@"FORM SELECTION VIEW");
    self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:190.0/255.0 blue:230.0 alpha:1];
    UILabel *choiceLabel = [[UILabel alloc]init];
    CGSize stringSize = [formSelection.label sizeWithAttributes:@{NSFontAttributeName:choiceLabel.font}];
    choiceLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height);
    RadioButton *choiceA = [[RadioButton alloc]initWithFrame:frame];
    
    //UISwitch *choiceA = [[UISwitch alloc]init];
    choiceA.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    [choiceA setCenter:self.center];
    [self addSubview:choiceA];
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
