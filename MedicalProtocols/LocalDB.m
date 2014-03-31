//
//  LocalDB.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 3/30/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "LocalDB.h"
#import "FMDB.h"
#import <Parse/Parse.h>
@implementation LocalDB

-(BOOL) createDB
{
    NSLog(@"CREATEDB");
    NSString *dbPath = @"protocols.db";
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if(![db open])
    {
        return NO;
    }
    else
    {
        [self loadDB];
        return YES;
    }
}

-(void) loadDB
{
    PFQuery *protocolQuery = [PFQuery queryWithClassName:@"Protocol"];
    [protocolQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
            NSLog(@"ERROR QUERYING PARSE: UNABLE TO PULL DOWN PROTOCOL DATA");
        for (PFObject *object in objects) {
            NSLog(@"%@", object.objectId);
        }}];
}


@end
