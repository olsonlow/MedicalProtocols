//
//  FormSelection.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormSelection.h"
#import "FormComponent.h"
#import <Parse/Parse.h>

@implementation FormSelection
-(id)initWithLabel:(NSString*)label choiceA:(NSString*)choiceA choiceB:(NSString*)choiceB objectId:(NSString*)objectId orderNumber:(int)orderNumber formId:(NSString*)formId{
    self = [super init];
    if (self) {
        _label = label;
        _choiceA = choiceA;
        _choiceB = choiceB;
        _objectId = objectId;
        _orderNumber = orderNumber;
        _formId = formId;
    }
    return self;
}

@end
