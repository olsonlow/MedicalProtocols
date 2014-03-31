//
//  Calculator.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Calculator.h"
#import <Parse/Parse.h>

@implementation Calculator
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        //        _name = parseObject[@"name"];
    }
    return self;
}
@end
