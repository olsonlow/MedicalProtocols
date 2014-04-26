//
//  TextFieldPropertyCell.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 23/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "TextFieldPropertyCell.h"

@implementation TextFieldPropertyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)value{
    return self.textField.text;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.value = @"";
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)textFinishedEditing:(UITextField*)sender {
    self.value = sender.text;
}
@end
