//
//  ComponentCell.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 22/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentCell.h"
#import "ProtocolDetailViewController.h"
@interface ComponentCell()
@property(nonatomic,strong) UIButton* cancelButton;
@end

@implementation ComponentCell
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wobbling = NO;
        // Initialization code
    }
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
- (void)startWobble {
    if(!self.wobbling){
        self.wobbling = YES;
        UIImage* cancelImage = [UIImage imageNamed:@"cancelIcon.png"];
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setImage:cancelImage forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(deleteCell:)
         forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.frame = CGRectMake(0, 0, 60, 60);
        [self addSubview:self.cancelButton];
        [self bringSubviewToFront:self.cancelButton];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = 0.6;
        self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        self.alpha = 0.8;
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-2));
        
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                         animations:^ {
                             self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
                         }
                         completion:NULL
         ];
    }
}
-(void)deleteCell:(id)sender{
    self.wobbling = NO;
    [self.delegate deleteCellAtindex:self.index];
}
- (void)stopWobble {
    self.wobbling = NO;
    [self.cancelButton removeFromSuperview];
    self.layer.shouldRasterize = NO;
    self.layer.rasterizationScale = 1;
    self.alpha = 1;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL
     ];
}
@end
