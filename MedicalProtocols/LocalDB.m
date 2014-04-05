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
#import "TextBlock.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"
#import "Link.h"
#import "Calculator.h"
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

-(NSArray*)getAll:(DataType)dataType{
   FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    switch (dataType) {
        case DataTypeProtocol:
            if(success)
            {
                [db open];
                NSMutableArray* protocols = [[NSMutableArray alloc] init];
                FMResultSet *results = [db executeQuery:@"SELECT * FROM protocol"];
                while([results next])
                {
                    MedProtocol *p = [[MedProtocol alloc] init];
                    p.name = [results stringForColumn:@"pName"];
                    p.idStr = [results stringForColumn:@"objectID"];
                    p.updatedAt = [results dateForColumn:@"updatedAt"];
                    p.createdAt = [results dateForColumn:@"createdAt"];
                    [protocols addObject:p];
                }
                if ([db hadError]) {
                    NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
                [db close];
                return protocols;
            }
            break;
        case DataTypeStep:
           
            if(success)
            {
                [db open];
                NSMutableArray* steps = [[NSMutableArray alloc] init];
                FMResultSet *results = [db executeQuery:@"SELECT * FROM step"];
                while([results next])
                {
                    ProtocolStep *step = [[ProtocolStep alloc] init];
                    step.stepNumber = [results intForColumn:@"stepNumber"];
                    step.description = [results stringForColumn:@"description"];
                    step.objectID = [results stringForColumn:@"objectID"];
                    step.protocolID = [results stringForColumn:@"protocolID"];
                    step.updatedAt = [results dateForColumn:@"updatedAt"];
                    step.createdAt = [results dateForColumn:@"createdAt"];
                    [steps addObject:step];
                }
                if ([db hadError]) {
                    NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
                
                [db close];
                return steps;
            }
                break;
            
        case DataTypeComponent:
            return[self getAllComponents];
            
        case DataTypeFormComponent:
            return[self getAllFormComponents];
        default:
            break;
    }
    
    return NULL;
}

-(NSArray *) getAllFormComponents
{
    NSMutableArray *formComponents = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *fsResults = [db executeQuery:@"SELECT * FROM formSelection"];
        while([fsResults next])
        {
            FormSelection *fs = [[FormSelection alloc]init];
            fs.formSeletionId = [fsResults stringForColumn:@"objectID"];
            fs.choiceA = [fsResults stringForColumn:@"choiceA"];
            fs.choiceB = [fsResults stringForColumn:@"choiceB"];
            fs.label = [fsResults stringForColumn:@"label"];
            fs.updatedAt = [fsResults dateForColumn:@"updatedAt"];
            fs.createdAt = [fsResults dateForColumn:@"createdAt"];
            fs.formId = [fsResults stringForColumn:@"formID"];
            [formComponents addObject:fs];
        }
        FMResultSet *fnResults = [db executeQuery:@"SELECT * from formNumber"];
        while ([fnResults next]) {
            FormNumber *fn = [[FormNumber alloc]init];
            fn.formNumberId = [fnResults stringForColumn:@"objectID"];
            fn.defaultValue = [fnResults intForColumn:@"defaultValue"];
            fn.minValue = [fnResults intForColumn:@"minValue"];
            fn.maxValue = [fnResults intForColumn:@"maxValue"];
            fn.label = [fnResults stringForColumn:@"label"];
            fn.updatedAt = [fnResults dateForColumn:@"updatedAt"];
            fn.createdAt = [fnResults dateForColumn:@"createdAt"];
            fn.formId = [fnResults stringForColumn:@"formID"];
            [formComponents addObject:fn];
        }
    }
    return formComponents;
}


-(NSArray*)getAllComponents
{
    NSMutableArray *components = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
   if(success)
    {
        [db open];
       
        FMResultSet *tbResults = [db executeQuery:@"SELECT * FROM textblock  "];
        while([tbResults next])
        {
            TextBlock *t = [[TextBlock alloc]init];
            t.title = [tbResults stringForColumn:@"title"];
            t.content = [tbResults stringForColumn:@"content"];
            t.printable = [tbResults boolForColumn:@"printable"];
            t.textBlockId = [tbResults stringForColumn:@"objectID"];
            t.updatedAt = [tbResults dateForColumn:@"updatedAt"];
            t.createdAt = [tbResults dateForColumn:@"createdAt"];
            t.stepId = [tbResults stringForColumn:@"stepID"];
           [components addObject:t];
        }
        
        FMResultSet *cResults = [db executeQuery:@"SELECT * FROM calculator  "];
        while([tbResults next])
        {
            Calculator *c = [[Calculator alloc]init];
            c.calculatorId = [cResults stringForColumn:@"objectID"];
            c.updatedAt = [cResults dateForColumn:@"updatedAt"];
            c.createdAt = [cResults dateForColumn:@"createdAt"];
            c.stepId = [cResults stringForColumn:@"stepID"];
            [components addObject:c];
        }
        
        FMResultSet *lResults = [db executeQuery:@"SELECT * FROM link  "];
        while([lResults next])
        {
            Link *l = [[Link alloc]init];
            l.linkId = [lResults stringForColumn:@"objectID"];
            l.url = [lResults stringForColumn:@"url"];
            l.updatedAt = [lResults dateForColumn:@"updatedAt"];
            l.createdAt = [lResults dateForColumn:@"createdAt"];
            l.label = [lResults stringForColumn:@"label"];
            l.printable = [lResults boolForColumn:@"printable"];
            l.stepId = [lResults stringForColumn:@"stepID"];
            [components addObject:l];
        }
       if ([db hadError]) {
           NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db close];
    }
    return components;
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
/*-(BOOL) insertData: (DataType *) dataType :
{
    //NSLog(@"INSERT PROTOCOL");
    FMDatabase *db = [FMDatabase databaseWithPath: self.databasePath];
    [db open];
    BOOL success = [db executeUpdate:@"INSERT INTO protocol (objectID, createdAt, updatedAt, pName) VALUES (?,?,?,?);", mp.idStr ,mp.createdAt, mp.updatedAt, mp.name, nil];
    return success;
}
*/
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
-(NSArray*)tableNamesForDataType:(DataType)dataType{
    NSArray* tableNames = nil;
    switch (dataType) {
        case DataTypeProtocol:
            tableNames =@[@"protocol"];
            break;
        case DataTypeStep:
            tableNames =@[@"step"];
        case DataTypeComponent:
            tableNames =@[@"form", @"link", @"calculator", @"textBlock"];
        case DataTypeFormComponent:
            tableNames = @[@"formNumber", @"formSelection"];
        default:
            break;
    }
    return tableNames;
}



@end
