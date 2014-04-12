//
//  ProtocolDetailViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import "MedRefBaseDetailViewController.h"

@class MedProtocol;
@interface ProtocolDetailViewController : MedRefBaseDetailViewController
@property (strong, nonatomic) MedProtocol* protocol;
@property (weak, nonatomic) IBOutlet UILabel *protocolName;
@property (weak, nonatomic) IBOutlet UILabel *protocolID;
@property (weak, nonatomic) IBOutlet UILabel *protocolSteps;
@end
