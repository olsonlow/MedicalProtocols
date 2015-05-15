//
//  TextAreaPropertyCell.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 23/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "TextAreaPropertyCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextAreaPropertyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(id)value{
    return self.textArea.text;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.value = @"";
    _textArea.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textArea.layer.borderWidth = 2;
    _textArea.layer.cornerRadius = 5;
    self.textArea.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.value = textView.text;
}
@end
