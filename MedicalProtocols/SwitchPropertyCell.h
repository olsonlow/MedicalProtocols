//
//  SwitchPropertyCell.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 23/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "BasePropertyCell.h"

@interface SwitchPropertyCell : BasePropertyCell
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)switchValueChanged:(UISwitch*)sender;

@end
