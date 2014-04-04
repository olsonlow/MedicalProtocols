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

#import "ProtocolStep.h"
#import "TextBlock.h"
#import "Link.h"
#import "Calculator.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"


@interface ProtocolDataController()
{

}
@property(nonatomic,strong) NSMutableArray* protocols;
@property (nonatomic, strong) LocalDB *lDB;
@end


@implementation ProtocolDataController
- (id)init
{
    self = [super init];
    if (self) {
        _protocols = [[NSMutableArray alloc] init];
        
//        PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];
//
//        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
//            for (PFObject* parseProtocolObject in results) {
//                [_protocols addObject:[[MedProtocol alloc] initWithParseObject:parseProtocolObject]];
//            }
//        }];
        PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d sprotocols.", objects.count);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    //[_protocols addObject:[[MedProtocol alloc] initWithParseObject:object]];
                    MedProtocol *mp = [[MedProtocol alloc]init];
                    mp.name =object[@"name"];
                    mp.idStr = object.objectId;
                    mp.name = object[@"name"];
                    mp.createdAt = object.createdAt;
                    mp.updatedAt = object.updatedAt;
                    [_protocols addObject:mp];
                    [self insertProtocol:mp];
                   
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        //set up in-app shared instance of database (medRef.db)
        _lDB = [[LocalDB alloc]LocalDBInit];
        
       //dummy test
//        MedProtocol *mp = [[MedProtocol alloc] init];
//        mp.idStr = @"obj49djec";
//        mp.name = @"Myocarditis";
//        NSDate *now = [[NSDate alloc]init];
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
//       mp.createdAt = [calendar dateFromComponents:components];
//        mp.updatedAt = [calendar dateFromComponents:components];
        //[self insertProtocol:mp];
        //[self populateFromDatabase]; //test to see if we can query the table
    }
    return self;
}



-(LocalDB *) lDB
{
    if(! _lDB)
        _lDB = [LocalDB sharedInstance];
    return _lDB;
}

-(NSMutableArray *) getProtocols
{
    return  self.protocols;
}

-(BOOL) insertProtocol:(MedProtocol *) mp
{
   //NSLog(@"INSERT PROTOCOL");
    FMDatabase *db = [FMDatabase databaseWithPath: _lDB.databasePath];
    [db open];
    BOOL success = [db executeUpdate:@"INSERT INTO protocol (objectID, createdAt, updatedAt, pName) VALUES (?,?,?,?);", mp.idStr ,mp.createdAt, mp.updatedAt, mp.name, nil];
    return success;
}

-(BOOL) updateProtocol: (MedProtocol *) mp
{
    FMDatabase *db = [FMDatabase databaseWithPath:_lDB.databasePath];
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
    _protocols = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:_lDB.databasePath];
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
        [_protocols addObject:protocol];
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
