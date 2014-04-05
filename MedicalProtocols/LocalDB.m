//
//  LocalDB.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 3/30/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//



//NOTE: TO RECREATE medRef.db FROM COMMAND LINE:  cat medRef.sql | sqlite3 medRef.db
#import "LocalDB.h"
#import "FMDB.h"
#import <Parse/Parse.h>
#import "MedProtocol.h"
#import "ProtocolStep.h"
#import "Component.h"
#import "DataSource.h"
@implementation LocalDB

-(id)init
{
    self = [super init];
    if (self) {
        NSLog(@"INITIALIZING LOCAL DB");
        self.databaseName = @"medRef.db";
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"Private Documents/MedProtocol/"];
        self.databasePath = [path stringByAppendingPathComponent:self.databaseName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:self.databasePath])
        {
            NSLog(@"COPYING DB FROM RESOURCES TO LIBRARY");
            NSString *fromPath = [[NSBundle mainBundle] bundlePath];
            fromPath = [fromPath stringByAppendingPathComponent:self.databaseName];
            NSError *createFileError = nil;
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path  withIntermediateDirectories:YES attributes:nil error:&createFileError]) {
                NSLog(@"Error copying files: %@", [createFileError localizedDescription]);
            }
            NSError *copyError = nil;
            if (![[NSFileManager defaultManager]copyItemAtPath:fromPath toPath:self.databasePath error:&copyError]) {
                NSLog(@"Error copying files: %@", [copyError localizedDescription]);
            }
        }
    }
    return self;
}

+(LocalDB *) sharedInstance
{
    static LocalDB* sharedObject = nil;
    if(sharedObject == nil)
        sharedObject = [[LocalDB alloc] init];
    return sharedObject;
}
-(NSArray*)getAllProtocols{
    NSMutableArray* protocols = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d sprotocols.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                MedProtocol *mp = [[MedProtocol alloc]init];
                mp.name =object[@"name"];
                mp.idStr = object.objectId;
                mp.createdAt = object.createdAt;
                mp.updatedAt = object.updatedAt;
                [protocols addObject:mp];
                //[self insertProtocol:mp];

            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return protocols;
}

-(NSArray*)getStepsForProtocolId:(NSString*)protocolId{
    return NULL;
}
-(NSArray*)getComponentsForStepId:(NSString*)stepId{
    return NULL;
}

//-(LocalDB *) lDB
//{
//    if(! _lDB)
//        _lDB = [LocalDB sharedInstance];
//    return _lDB;
//}
-(BOOL) insertProtocol:(MedProtocol *) mp
{
    //NSLog(@"INSERT PROTOCOL");
    FMDatabase *db = [FMDatabase databaseWithPath: self.databasePath];
    [db open];
    BOOL success = [db executeUpdate:@"INSERT INTO protocol (objectID, createdAt, updatedAt, pName) VALUES (?,?,?,?);", mp.idStr ,mp.createdAt, mp.updatedAt, mp.name, nil];
    return success;
}

-(BOOL) updateProtocol: (MedProtocol *) mp
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE protocol SET pName = '%@', updatedAt = '%@' where id = %@",mp.name, mp.updatedAt,mp.idStr]];
    [db close];
    return success;
}
//Create a method that builds a protocol from the onboard database
-(void)populateFromDatabase : (NSMutableArray *) protocolArr
{
    protocolArr = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM protocol"];
    while([results next])
    {
        MedProtocol *protocol = [[MedProtocol alloc] init];
        protocol.name = [results stringForColumn:@"pName"];
        NSLog(@"NAME: %@", protocol.name);
        protocol.protocolId = [results stringForColumn:@"objectID"];
        protocol.createdAt = [results dateForColumn:@"createdAt"];
        protocol.updatedAt = [results dateForColumn:@"updatedAt"];
        [protocolArr addObject:protocol];
    }
    [db close];
}




@end
