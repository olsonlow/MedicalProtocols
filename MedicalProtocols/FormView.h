//
//  FormView.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson, Zach Dahlgren, and Lowell Olson on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "Form.h"
@interface FormView : ComponentView
@property (strong, nonatomic) Form *form;
-(id) initWithFrame:(CGRect)frame andForm:(Form *) form;
@end
