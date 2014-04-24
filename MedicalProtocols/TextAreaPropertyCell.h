//
//  TextAreaPropertyCell.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 23/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextAreaPropertyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textArea;

@end
