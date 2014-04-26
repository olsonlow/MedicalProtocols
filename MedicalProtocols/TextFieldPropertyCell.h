//
//  TextFieldPropertyCell.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 23/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "BasePropertyCell.h"

@interface TextFieldPropertyCell : BasePropertyCell
- (IBAction)textFinishedEditing:(UITextField*)sender;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
