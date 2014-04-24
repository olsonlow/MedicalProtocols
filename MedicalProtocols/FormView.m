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
    for(int i = 0; i < [form countFormComonents]; i++)
    {
        CGRect compFrame = CGRectMake(frame.origin.x-10,frame.origin.y +(frame.size.height/3 * i)-10, frame.size.width, frame.size.height/3);
        FormComponent *formComponent = [form formComponentAtIndex:i];
        NSLog(@"CHECK ME: %@", formComponent.label);
        FormComponentView *formComponentView = [[FormComponentView alloc]initWithFrame:compFrame Object:formComponent];
        [self addSubview:formComponentView];
    }
    
    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);name.text = @"Form";
    CGSize nameStringSize = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
    name.frame = CGRectMake(frame.origin.x, frame.origin.y, nameStringSize.width, nameStringSize.height);
    
    [self addSubview:name];
    NSLog(@"%d",self.userInteractionEnabled);

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
