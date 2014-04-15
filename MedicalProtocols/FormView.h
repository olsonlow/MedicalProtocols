//
//  FormView.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "Form.h"
@interface FormView : ComponentView
@property (strong, nonatomic) Form *form;
-(id) initWithFrame:(CGRect)frame andForm:(Form *) form;
@end
