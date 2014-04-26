//
//  SwitchPropertyCell.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 23/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "SwitchPropertyCell.h"

@implementation SwitchPropertyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.value = [NSNumber numberWithBool:NO];
    // Initialization code
}
-(id)value{
    return self.label.text;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(UISwitch*)sender {
    self.value = [NSNumber numberWithBool:sender.on];
}
@end
