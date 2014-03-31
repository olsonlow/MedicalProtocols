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
