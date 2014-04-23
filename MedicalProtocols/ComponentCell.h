//
//  ComponentCell.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 22/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProtocolDetailViewController;
@interface ComponentCell : UICollectionViewCell
@property(nonatomic,strong) ProtocolDetailViewController* delegate;
@property(nonatomic,assign) int index;
@property(nonatomic,assign) BOOL wobbling;
- (void)startWobble;
- (void)stopWobble;
@end
