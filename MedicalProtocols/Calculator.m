//
//  Calculator.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator
-(id)init{
    return [self initWithObjectId:@"" stepId:@"" orderNumber:-1];
}
-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super initWithStepId:stepId OrderNumber:orderNumber];
    if (self) {
        _objectId = objectId;
    }
    return self;
}

@end
