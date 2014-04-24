//
//  ComponentModalViewController.h
//  MedicalProtocols
//
//  Created by Lowell D. Olson on 4/18/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Component;
@class ProtocolDetailViewController;

@interface ComponentModalViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) Component* component;
@property(nonatomic,strong) ProtocolDetailViewController* delegate;

@end
