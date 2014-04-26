//
//  Calculator.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator
-(id)init{
    return [self initWithObjectId:[[[NSUUID alloc] init] UUIDString] stepId:@"" orderNumber:-1];
}
-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super initWithObjectId:objectId StepId:stepId OrderNumber:orderNumber  componentType:ComponentTypeCalculator];
    if (self) {
        //_objectId = objectId;
    }
    return self;
}
-(int)numberOfEditableProperties{
    return 0;
}
@end
