//
//  EditableTableViewCell.h
//  MedicalProtocols
//
//  Created by Lowell D. Olson on 4/26/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseMasterTableViewController;
@interface EditableTableViewCell : UITableViewCell <UITextFieldDelegate>
@property(nonatomic,strong) BaseMasterTableViewController* delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
