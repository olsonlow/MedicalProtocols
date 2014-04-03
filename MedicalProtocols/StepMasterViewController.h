//
//  StepMasterViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 2/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedProtocol;
@class ProtocolDetailViewController;
@interface StepMasterViewController : UITableViewController

@property (strong,nonatomic) MedProtocol* protocolData;
@property (strong, nonatomic) ProtocolDetailViewController *detailViewController;

@end
