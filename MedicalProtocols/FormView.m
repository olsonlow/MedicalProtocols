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
    self.backgroundColor = [UIColor whiteColor];
    int origin = 0;
    for(int i = 0; i < [form countFormComonents]; i++)
    {
        CGRect compFrame = CGRectMake(frame.origin.x-10,frame.origin.y-10 + origin, frame.size.width, 150);//height used to be set to 150
        FormComponent *formComponent = [form formComponentAtIndex:i];
        FormComponentView *formComponentView = [[FormComponentView alloc]initWithFrame:compFrame Object:formComponent];
        [self addSubview:formComponentView];
        origin += 100;
    }
    
    UIButton *done =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [done addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    [done setTitle:@"DONE" forState:UIControlStateNormal];
    done.frame = CGRectMake(frame.origin.x, frame.origin.y, 50,20); done.titleLabel.text= @"DONE";

    [self addSubview:done];
    NSLog(@"%d",self.userInteractionEnabled);

    return self;
}



- (IBAction)didClick:(UIButton *)sender
{
    for(int i = 0; i < [self.form countFormComonents];i++)
    {
        if([self.form formComponentAtIndex:i].valueSet == NO)
        {
            [[[UIAlertView alloc] initWithTitle:@"Whoops!"
                                        message:@"You haven't provided all the required information"
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
                return;
        }
    }

    [[[UIAlertView alloc] initWithTitle:@"Form Complete"
                                message:@"Here are the results produces based on the data: "
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
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
