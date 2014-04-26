//
//  FormComponent.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson, Zach Dahlgren, and Lowell Olson on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormComponent.h"
#import "FormNumber.h"
#import "FormSelection.h"
@implementation FormComponent
-(id)initWithFormId:(NSString*)formId orderNumber:(int)orderNumber label:(NSString*)label{
    self = [super init];
    if (self) {
        _label = label;
        _formId = formId;
        _orderNumber = orderNumber;
    }
    return self;
}
@end
