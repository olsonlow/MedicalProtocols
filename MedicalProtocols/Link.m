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
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _label = parseObject[@"label"];
        _url = parseObject[@"URL"];
    }
    return self;
}

-(id)initFromDBWithStepID:(NSObject*)DBObject{
    self = [super init];
    if (self) {
        NSString *dbPath = @"medRef.db";
        
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        [db open];
        FMResultSet *results = [db executeQuery:@"SELECT * FROM link where stepID = ?"];
        while([results next])
        {
            _label = [results stringForColumn:@"label"];
            _url = [results stringForColumn:@"url"];
            
        }
        
        [db close];
    }
    return self;
}
-(BOOL)printable{
    return NO;
}

@end
