//
//  StepMasterViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 2/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "BaseMasterTableViewController.h"
#import "DataSourceProtocols.h"
@class MedProtocol;
@class ProtocolStep;
@class ProtocolDetailViewController;
@interface StepMasterViewController : BaseMasterTableViewController<MedRefDataSourceDelegate>

@property (strong,nonatomic) MedProtocol* protocolData;
@property (strong, nonatomic) ProtocolDetailViewController *detailViewController;

@end
