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
    self.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:190.0/255.0 blue:230.0 alpha:1];
    UILabel *choiceLabel = [[UILabel alloc]init];
    CGSize stringSize = [formSelection.label sizeWithAttributes:@{NSFontAttributeName:choiceLabel.font}];
    choiceLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height);
   
    RadioButton *choiceA = [[RadioButton alloc]initWithFrame:frame];
    choiceA.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    choiceA.titleLabel.text = formSelection.label;
    [choiceA setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [choiceA setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    choiceA.frame = CGRectMake(frame.origin.x, frame.origin.y, 24, 24);
    choiceA.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [choiceA setCenter:self.center];
    
    RadioButton *choiceB = [[RadioButton alloc]initWithFrame:frame];
    choiceB.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    choiceB.titleLabel.text = formSelection.label;
    [choiceB setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [choiceB setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    choiceB.frame = CGRectMake(frame.origin.x, frame.origin.y, 24, 24);
    choiceB.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [choiceB setCenter:CGPointMake(self.center.x+50, self.center.y)];
    
    choiceB.groupButtons =@[choiceA];
    [self addSubview:choiceA];
    [self addSubview:choiceB];
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
