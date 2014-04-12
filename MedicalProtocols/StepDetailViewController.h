//
//  StepDetailViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 11/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "MedRefBaseDetailViewController.h"

@class MedProtocol;
@interface StepsDetailViewController : MedRefBaseDetailViewController
@property (strong, nonatomic) MedProtocol* protocol;
@end
