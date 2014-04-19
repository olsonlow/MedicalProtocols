//
//  FormView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormView.h"
#import "FormComponentView.h"
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
    //self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:218.0/255.0 blue:185.0/255.0 alpha:1.0];
    
    NSLog(@"FORM COMONENTS: %d", [form countFormComonents]);
    for(int i = 0; i < [form countFormComonents]; i++)
    {
        NSLog(@"ADDING FORM COMPONENTS");
        FormComponent *formComponent = [form formComponentAtIndex:i];
        NSLog(@"%@",formComponent.label);
        FormComponentView *formComponentView = [[FormComponentView alloc]initWithFrame:frame Object:formComponent];
        [formComponentView setCenter:self.center];
        [self addSubview:formComponentView];
    }
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);name.text = @"Form";
    CGSize nameStringSize = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
    name.frame = CGRectMake(frame.origin.x, frame.origin.y, nameStringSize.width, nameStringSize.height);
    
    [self addSubview:name];
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
