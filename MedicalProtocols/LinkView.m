//
//  LinkView.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson, Zach Dahlgren, and Lowell Olson on 4/12/14.
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
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize stringSize = [self.link.label sizeWithAttributes:@{NSFontAttributeName:linkButton.titleLabel.font}];
    [linkButton setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    [linkButton setCenter: CGPointMake(frame.size.width/2, frame.size.height/2)];
    [linkButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [linkButton setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
    [linkButton setBackgroundColor:[UIColor whiteColor]];
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
