//
//  TextAreaPropertyCell.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 23/04/2014.
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    _textArea.layer.BorderColor = [[UIColor lightGrayColor] CGColor];
    _textArea.layer.BorderWidth = 2;
    _textArea.layer.CornerRadius = 5;
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
