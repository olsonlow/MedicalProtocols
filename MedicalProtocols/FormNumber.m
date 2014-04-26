//
//  FormNumber.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormNumber.h"
#import "FormComponent.h"
#import <Parse/Parse.h>

@implementation FormNumber
-(id)initWithLabel:(NSString*)label defaultValue:(int)defaultValue minValue:(int)minValue maxValue:(int)maxValue objectId:(NSString*)objectId orderNumber:(int)orderNumber formId:(NSString*)formId{
    self = [super initWithFormId:formId orderNumber:orderNumber label:label];
    if (self) {
        _defaultValue = defaultValue;
        _maxValue = maxValue;
        _minValue = minValue;
    }
    return self;
}

@end
