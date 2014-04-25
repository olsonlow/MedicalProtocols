//
//  BaseMasterTableViewController.h
//  MedicalProtocols
//
//  Created by Lowell D. Olson on 4/24/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseMasterTableViewController : UITableViewController
@property(nonatomic,assign) BOOL editable;
-(void)refreshView;
@end
