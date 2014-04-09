//
//  FormSelection.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormSelection.h"
#import <Parse/Parse.h>

@implementation FormSelection
-(id)initWithLabel:(NSString*)label choiceA:(NSString*)choiceA choiceB:(NSString*)choiceB objectId:(int)objectId formId:(int)formId{
    self = [super init];
    if (self) {
        _label = label;
        _choiceA = choiceA;
        _choiceB = choiceB;
        _objectId = objectId;
        _formId = formId;
    }
    return self;
}
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _label = parseObject[@"label"];
        _choiceA = parseObject[@"choiceA"];
        _choiceB = parseObject[@"choiceB"];
    }
    return self;
}
@end
