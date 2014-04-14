//
//  StepDetailViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 11/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "MedRefBaseDetailViewController.h"
@class MedProtocol;
@class ProtocolStep;
@interface StepDetailViewController : MedRefBaseDetailViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) MedProtocol* protocol;
@property (strong, nonatomic) ProtocolStep *step;
-(void)setStep:(ProtocolStep *)step;
@end
