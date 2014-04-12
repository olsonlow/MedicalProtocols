//
//  StepMasterViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 2/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceProtocols.h"
@class MedProtocol;
@class StepDetailViewController;
@interface StepMasterViewController : UITableViewController<MedRefDataSourceDelegate>

@property (strong,nonatomic) MedProtocol* protocolData;
@property (strong, nonatomic) StepDetailViewController *detailViewController;

@end
