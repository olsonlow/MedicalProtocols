//
//  Link.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Link.h"
#import <Parse/Parse.h>
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation Link
-(id)initWithLabel:(NSString*)label url:(NSString*)url objectId:(NSString*)objectId stepId:(NSString*)stepId{
    self = [super init];
    if (self) {
        _label = label;
        _url = url;
        _objectId = objectId;
        _stepId = stepId;
    }
    return self;
}

@end
