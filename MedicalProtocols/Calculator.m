//
//  Calculator.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Calculator.h"
#import <Parse/Parse.h>
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation Calculator
-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId{
    self = [super init];
    if (self) {
        _objectId = objectId;
        _stepId = stepId;
    }
    return self;
}
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        //        _name = parseObject[@"name"];
    }
    return self;
}

-(id)initWithDBObject:(NSObject*)DBObject{
    self = [super init];
    if (self) {
        NSString *dbPath = @"medRef.db";
        
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        [db open];
        FMResultSet *results = [db executeQuery:@"SELECT * FROM calculator"];
        while([results next])
        {
            _objectId = [results stringForColumn:@"objectID"];
            _stepId = [results stringForColumn:@"stepID"];
            
        }
        
        [db close];
    }
    return self;
}
@end
