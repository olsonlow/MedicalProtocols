//
//  StepBuilderMasterViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 15/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProtocolStep;
@class ProtocolDetailViewController;
@interface StepBuilderMasterViewController : UITableViewController
@property (strong, nonatomic) ProtocolDetailViewController *detailViewController;
@property(nonatomic,strong) ProtocolStep* step;
@end
