//
//  ProtocolMasterViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import "BaseMasterTableViewController.h"
#import "DataSourceProtocols.h"

@class ProtocolDetailViewController;

@interface ProtocolMasterViewController : BaseMasterTableViewController<MedRefDataSourceDelegate>

@property (strong, nonatomic) ProtocolDetailViewController *detailViewController;

@end
