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
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _title = parseObject[@"title"];
        _content = parseObject[@"content"];
        _printable = [parseObject[@"printable"] boolValue];
    }
    return self;
}

-(id)initWithDBObject:(NSObject*)DBObject{
    self = [super init];
    if (self) {
        NSString *dbPath = @"medRef.db";
        
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        [db open];
        FMResultSet *results = [db executeQuery:@"SELECT * FROM textblock"];
        while([results next])
        {
            _title = [results stringForColumn:@"title"];
            _content = [results stringForColumn:@"content"];
            _printable = [results boolForColumn:@"printable"];
            
        }
        
        [db close];
    }
    return self;
}
@end
