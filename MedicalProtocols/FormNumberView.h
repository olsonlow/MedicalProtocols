//
//  FormNumberView.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormView.h"
#import "FormComponentView.h"
#import "FormNumber.h"
@interface FormNumberView : FormComponentView
-(id) initWithFrame:(CGRect)frame andFormNumber:(FormNumber *)formNumber;


@end
