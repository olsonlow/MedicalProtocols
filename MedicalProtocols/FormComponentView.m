//
//  FormComponentView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormComponentView.h"
#import "FormSelectionView.h"
#import "FormNumberView.h"
@implementation FormComponentView

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
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor greenColor];
    FormComponentView * formComponentView = [FormComponentView formComponentWithFrame:frame Object:object];
    formComponentView.center = CGPointMake(frame.size.height/2, frame.size.width/2);
    [self addSubview:formComponentView];
    return self;
}
+(FormComponentView *)formComponentWithFrame:(CGRect)frame Object:(id)object
{
    FormComponentView * result;
    if([object isKindOfClass:[FormNumber class]])
    {
        //create and add a form number view
        result = [[FormNumberView alloc]initWithFrame: frame andFormNumber:object];
    }
    else if([object isKindOfClass:[FormSelection class]])
    {
        //create and add a form selection view
        result = [[FormSelectionView alloc]initWithFrame:frame andFormSelection:object];
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
