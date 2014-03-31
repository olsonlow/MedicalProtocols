//
//  LocalDB.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 3/30/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "LocalDB.h"
#import "FMDB.h"
@implementation LocalDB

-(BOOL) createDB
{
    NSString *dbPath = @"protocols.db";
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if(![db open])
    {
        return NO;
    }
    else
        return YES;
}


@end
