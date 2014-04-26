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
    self.backgroundColor = [UIColor yellowColor];
    self.formSelection = formSelection;
    self.formSelection.valueSet = NO;
    UILabel *selectionLabel = [[UILabel alloc]init];
    CGSize stringSize = [formSelection.label sizeWithAttributes:@{NSFontAttributeName:selectionLabel.font}];
    selectionLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height);
    selectionLabel.text = formSelection.label;
    [selectionLabel setCenter:CGPointMake(self.center.x+25, self.center.y-25)];
    
    RadioButton *choiceA = [[RadioButton alloc]initWithFrame:frame];
    choiceA.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [choiceA setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [choiceA setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    choiceA.frame = CGRectMake(frame.origin.x, frame.origin.y, 24, 24);
    //choiceA.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [choiceA setCenter:self.center];
    [choiceA addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *choiceALabel = [[UILabel alloc]init];
    CGSize choiceAstringSize = [formSelection.choiceA sizeWithAttributes:@{NSFontAttributeName:choiceALabel.font}];
    choiceALabel.frame = CGRectMake(choiceA.frame.origin.x-12, frame.origin.y, choiceAstringSize.width, choiceAstringSize.height);
    choiceALabel.text = formSelection.choiceA;
    [choiceALabel setCenter:CGPointMake(choiceALabel.frame.origin.x-(choiceAstringSize.width)/2+1, choiceA.center.y)];
    
    RadioButton *choiceB = [[RadioButton alloc]initWithFrame:frame];
    choiceB.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [choiceB setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [choiceB setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    choiceB.frame = CGRectMake(frame.origin.x, frame.origin.y, 24, 24);
    [choiceB setCenter:CGPointMake(self.center.x+50, self.center.y)];
    [choiceB addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *choiceBLabel = [[UILabel alloc]init];
    CGSize choiceBstringSize = [formSelection.choiceB sizeWithAttributes:@{NSFontAttributeName:choiceBLabel.font}];
    choiceBLabel.frame = CGRectMake(choiceB.frame.origin.x+25, frame.origin.y, choiceBstringSize.width, choiceBstringSize.height);
    choiceBLabel.text = formSelection.choiceB;
    [choiceBLabel setCenter:CGPointMake(choiceBLabel.frame.origin.x+(choiceBstringSize.width)/2+1, choiceB.center.y)];
    
     //in here, we must get the value of the button that the user pressed and pass that back to the Form to store in an array, which later will be passed to formAlgorithm to compute
    
    choiceB.groupButtons =@[choiceA];
    [self addSubview:selectionLabel];
    [self addSubview:choiceALabel];
    [self addSubview:choiceBLabel];
    [self addSubview:choiceA];
    [self addSubview:choiceB];
    
    return self;
}

- (IBAction)didSelect:(RadioButton *)sender
{
    self.formSelection.valueSet = YES;
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
