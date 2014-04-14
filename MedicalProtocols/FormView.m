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
    [self formatDisplay];
    return self;
}

-(void) formatDisplay
{
    UILabel *formId;
    formId.text = self.form.objectId;
    [formId setCenter:self.center];
    [self addSubview:formId];
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
