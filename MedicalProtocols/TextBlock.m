//
//  TextBlock.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "TextBlock.h"
#import <Parse/Parse.h>
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation TextBlock
-(id)initWithTitle:(NSString*)title content:(NSString*)content printable:(bool)printable objectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _objectId = objectId;
        _stepId = stepId;
        _printable = printable;
        _orderNumber = orderNumber;
    }
    return self;
}


@end
