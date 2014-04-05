//
//  DataSource.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "DataSource.h"
#import "LocalDB.h"
#import "ParseDataSource.h"

@interface DataSource()
-(id<medRefDataSource>)getDataSource;
@end

@implementation DataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(id<medRefDataSource>)getDataSource{
    return NULL;
}

-(NSArray*)getAll:(DataType)dataType{
    id<medRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAll:dataType];
}
-(NSArray*)getAll:(DataType)dataType withParentId:(NSString*)parentId{
    return NULL;
}
-(bool)updateDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    return NULL;
}
-(bool)deleteDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}
-(bool)insertDataType:(DataType)dataType withObject:(id)object{
    return NULL;
}
-(bool)getObjectDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}

//-(NSArray*)getAllProtocols{
//    NSMutableArray* protocols = [[NSMutableArray alloc] init];
//    PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %d sprotocols.", objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                //[_protocols addObject:[[MedProtocol alloc] initWithParseObject:object]];
//                MedProtocol *mp = [[MedProtocol alloc]init];
//                mp.name =object[@"name"];
//                mp.idStr = object.objectId;
//                mp.createdAt = object.createdAt;
//                mp.updatedAt = object.updatedAt;
//                [protocols addObject:mp];
//                //[self insertProtocol:mp];
//
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//
//    //set up in-app shared instance of database (medRef.db)
//    _lDB = [[LocalDB alloc]LocalDBInit];
//    return protocols;
//}

//-(LocalDB *) lDB
//{
//    if(! _lDB)
//        _lDB = [LocalDB sharedInstance];
//    return _lDB;
//}
//-(BOOL) insertProtocol:(MedProtocol *) mp
//{
//    //NSLog(@"INSERT PROTOCOL");
//    FMDatabase *db = [FMDatabase databaseWithPath: _lDB.databasePath];
//    [db open];
//    BOOL success = [db executeUpdate:@"INSERT INTO protocol (objectID, createdAt, updatedAt, pName) VALUES (?,?,?,?);", mp.idStr ,mp.createdAt, mp.updatedAt, mp.name, nil];
//    return success;
//}
//
//-(BOOL) updateProtocol: (MedProtocol *) mp
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:_lDB.databasePath];
//    [db open];
//    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE protocol SET pName = '%@', updatedAt = '%@' where id = %@",mp.name, mp.updatedAt,mp.idStr]];
//    [db close];
//    return success;
//}
////Create a method that builds a protocol from the onboard database
//-(void)populateFromDatabase
//{
//    _protocols = [[NSMutableArray alloc] init];
//    FMDatabase *db = [FMDatabase databaseWithPath:_lDB.databasePath];
//    [db open];
//    FMResultSet *results = [db executeQuery:@"SELECT * FROM protocol"];
//    while([results next])
//    {
//        MedProtocol *protocol = [[MedProtocol alloc] init];
//        protocol.name = [results stringForColumn:@"pName"];
//        NSLog(@"NAME: %@", protocol.name);
//        protocol.protocolId = [results stringForColumn:@"objectID"];
//        protocol.createdAt = [results dateForColumn:@"createdAt"];
//        protocol.updatedAt = [results dateForColumn:@"updatedAt"];
//        [_protocols addObject:protocol];
//    }
//    [db close];
//}

@end
