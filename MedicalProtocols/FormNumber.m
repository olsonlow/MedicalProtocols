//
//  FormNumber.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormNumber.h"
#import "FormComponent.h"
#import <Parse/Parse.h>

@implementation FormNumber
-(id)initWithLabel:(NSString*)label defaultValue:(int)defaultValue minValue:(int)minValue maxValue:(int)maxValue objectId:(NSString*)objectId formId:(NSString*)formId{
    if (self) {
        _label = label;
        _defaultValue = defaultValue;
        _maxValue = maxValue;
        _minValue = minValue;
        _objectId = objectId;
        _formId = formId;
    }
    return self;
}

@end
