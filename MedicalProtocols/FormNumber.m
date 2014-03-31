//
//  FormNumber.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormNumber.h"
#import <Parse/Parse.h>

@implementation FormNumber
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _label = parseObject[@"label"];
        _defaultValue = parseObject[@"defaultValue"];
        _maxValue = parseObject[@"maxValue"];
        _minValue = parseObject[@"minValue"];
    }
    return self;
}
@end
