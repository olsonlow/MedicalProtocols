//
//  ProtocolDataController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolDataController.h"
#import "MedProtocol.h"
#import <Parse/Parse.h>
#import "FMDB.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ProtocolDataController()
@property(nonatomic,strong) NSMutableArray* protocols;
@property(nonatomic) MedProtocol* protocol;

@end

@implementation ProtocolDataController
- (id)init
{
    self = [super init];
    if (self) {
        _protocols = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];

        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseProtocolObject in results) {
                [_protocols addObject:[[MedProtocol alloc] initWithParseObject:parseProtocolObject]];
            }
        }];
        
        //set up in-app database (medRef.db)
        self.databaseName = @"medRef.db";
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"Private Documents/MedProtocol/"];
        self.databasePath = [path stringByAppendingPathComponent:self.databaseName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:self.databasePath];
        if(!success)
        {
            NSLog(@"COPYING DB FROM RESOURCES TO LIBRARY");
            NSString *fromPath = [[NSBundle mainBundle] bundlePath];
            fromPath = [fromPath stringByAppendingPathComponent:self.databaseName];
            NSError *copyError = nil;
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path  withIntermediateDirectories:YES attributes:nil error:&copyError]) {
                NSLog(@"Error copying files: %@", [copyError localizedDescription]);
            }
            if (![[NSFileManager defaultManager]copyItemAtPath:fromPath toPath:self.databasePath error:&copyError]) {
                NSLog(@"Error copying files: %@", [copyError localizedDescription]);
            }

            [self createAndCheckDatabase];
        }
        
        else
        {
            [self createAndCheckDatabase];
        }
        
        //load the database from self.protocols
        //NSLog(@"NUM. PROTOCOLS: %d", [self.protocols count]);
        for(int i = 0; i < [self.protocols count]; i++)
        {
            MedProtocol *mp = [self.protocols objectAtIndex:i];
            [self insertProtocol:mp];
        }
        
        //dummy test
        MedProtocol *mp = [[MedProtocol alloc] init];
        mp.idStr = @"obj49djec";
        mp.name = @"Myocarditis";
        NSDate *now = [[NSDate alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        mp.createdAt = [calendar dateFromComponents:components];
        mp.updatedAt = [calendar dateFromComponents:components];
        [self insertProtocol:mp];
        [self populateFromDatabase]; //test to see if we can query the table
    }
    return self;
}

-(void) createAndCheckDatabase
{
    //NSLog(@"CREATE AND CHECK DATABASE");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        NSLog(@"FILE PATH: %@ EXISTS", self.databasePath);
        return;
    } else {
        [NSException raise:@"database not found" format:@"we might have to create it programmatically :( tell Luke"];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
    }
}

-(NSMutableArray *) getProtocols
{
    return  self.protocols;
}

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

-(NSMutableArray *)protocols{
    if (_protocols == nil)
        _protocols = [[NSMutableArray alloc] init];
    return _protocols;
}

//Create a method that builds a protocol from the onboard database
-(void)populateFromDatabase
{
    self.protocols = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath]; //Lowell: I changed this line to use our property databasePath -Zach
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM protocol"];
    while([results next])
    {
        MedProtocol *protocol = [[MedProtocol alloc] init];
        protocol.name = [results stringForColumn:@"pName"];
        NSLog(@"PROTOCOL NAME: %@", protocol.name);
        //[protocol stepAtIndex:0];
        [protocol initdbPath:self.databasePath];
        self.protocol = [protocol initWithName:protocol.name steps:protocol.steps];
        [self.protocols addObject:protocol];
    }
    [db close];
}



-(int)countProtocols{
    return [self.protocols count];
}
-(MedProtocol*)protocolAtIndex:(int)index{
    return [self.protocols objectAtIndex:index];
}
@end
