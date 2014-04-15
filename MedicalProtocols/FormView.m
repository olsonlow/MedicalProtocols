//
//  FormView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormView.h"

@implementation FormView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect) frame andForm:(Form *)form
{
    self = [super initWithFrame:frame];
    self.form = form;
    self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.backgroundColor = [UIColor colorWithRed:255.0 green:218.0 blue:185.0 alpha:1.0];
   
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    name.center = CGPointMake(name.frame.size.height/2, name.frame.size.width/4);
    name.text = @"Form";
    
    UILabel *formId = [[UILabel alloc]init];
    formId.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    [formId setCenter:self.center];
    formId.text = self.form.objectId;
    
    [self addSubview:name];
    [self addSubview:formId];
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
