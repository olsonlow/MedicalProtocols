//
//  LinkView.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "LinkView.h"

@implementation LinkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andLink:(Link*)link
{
    self = [super initWithFrame:frame];
    self.link = link;
    self.backgroundColor = [UIColor colorWithRed:230.0 green:249.0 blue:200.0 alpha:1];
    //self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize stringSize = [self.link.label sizeWithAttributes:@{NSFontAttributeName:linkButton.titleLabel.font}];
    linkButton.frame = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height);
    [linkButton setNeedsDisplay];
    linkButton.backgroundColor = [UIColor darkGrayColor];
    [linkButton setTitle:self.link.label forState:UIControlStateNormal];
    [linkButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:linkButton];
    return self;
}

-(void)buttonPressed:(id)sender{
    NSURL *url = [NSURL URLWithString:self.link.url];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
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
