//
//  ProtocolMasterViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import <UIKit/UIKit.h>

@class ProtocolDetailViewController;

@interface ProtocolMasterViewController : UITableViewController

@property (strong, nonatomic) ProtocolDetailViewController *detailViewController;

@end
