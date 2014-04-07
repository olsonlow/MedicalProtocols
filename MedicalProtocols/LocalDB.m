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


-(NSArray*)getAll:(DataType)dataType withParentId:(NSString*)parentId{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    switch (dataType) {
        case DataTypeProtocol:
            if(success)
            {
                [db open];
                NSMutableArray *protocols = [[NSMutableArray alloc]init];
                FMResultSet *results;
                if(parentId)
                    return NULL;
                else
                    results = [db executeQuery:@"SELECT * FROM protocol"];
                while([results next])
                {
                    MedProtocol *mp = [[MedProtocol alloc]init];
                    mp.idStr = [results stringForColumn:@"objectID"];
                    mp.name = [results stringForColumn:@"pName"];
                    mp.updatedAt = [results dateForColumn:@"updatedAt"];
                    mp.createdAt = [results dateForColumn:@"createdAt"];
                    [protocols addObject:mp];
                }
                if ([db hadError]) {
                    NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
                [db close];
                return protocols;
            }
            
        case DataTypeStep:
            if(success)
            {
                [db open];
                NSMutableArray* steps = [[NSMutableArray alloc] init];
                FMResultSet *results;
                if(parentId){
                    results = [db executeQuery:@"SELECT * FROM step WHERE protocolID = ?", parentId];
                } else {
                    results = [db executeQuery:@"SELECT * FROM step"];
                }
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
        case DataTypeComponent:
            return[self getAllComponents];
        case DataTypeFormComponent:
            return[self getAllFormComponents];
        default:
            break;
    }
    
    return NULL;
}

//NEED TO COMPLETE
-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    //NSArray *tableName = [self tableNamesForDataType:dataType];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *mp = (MedProtocol*) object;
        success = [db executeUpdate:@"UPDATE protocol SET objectID = ?, pName = ?, createdAt = ?, updatedAt = ? WHERE objectID = ? ",mp.idStr, mp.name, mp.createdAt, mp.updatedAt, idString];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *ps = (ProtocolStep *)object;
        success = [db executeUpdate:@"UPDATE step SET objectID = ?, stepNumber = ?, createdAt = ?, updatedAt = ?, protocolID = ? , description = ? WHERE objectID = ?", ps.objectID, ps.stepNumber, ps.createdAt, ps.updatedAt, ps.protocolID, ps.description, idString];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        
    }
    else if([object isKindOfClass:[Link class]])
    {
        
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        
    }
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    //BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    //FMResultSet * result;
    //if(success)
   // {
    //    [db open];
    //    result = [db executeQuery:@"UPDATE"];
    //}
   /// if ([db hadError]) {
      //  NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
   // }
    //[db close];
    //return result;
    
    return NULL;
}

//NEED TO COMPLETE
-(bool)insertDataType:(DataType)dataType withObject:(id)object{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *mp = (MedProtocol *)object;
        success =  [db executeUpdate:@"INSERT INTO protocol VALUES (?,?,?,?)", mp.idStr, mp.name,  mp.createdAt, mp.updatedAt];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *ps = (ProtocolStep*)object;
        success =  [db executeUpdate:@"INSERT INTO step VALUES (?,?,?,?,?,?)",ps.objectID, ps.stepNumber, ps.createdAt, ps.updatedAt, ps.protocolID, ps.description];
    }
    
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *tb = (TextBlock *) object;
        success = [db executeUpdate:@"INSERT INTO textBlock VALUES (?,?,?,?,?,?)", tb.textBlockId, tb.createdAt, tb.updatedAt, tb.printable, tb.title, tb.stepId];
    }
    
    else if([object isKindOfClass:[Link class]])
    {
        Link *l = (Link *)object;
        success = [db executeUpdate:@"INSERT INTO link VALUES (?,?,?,?,?,?,?)", l.linkId, l.url, l.createdAt, l.updatedAt, l.printable, l.label, l.stepId];
    }
    
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *c = (Calculator *)object;
        success = [db executeUpdate:@"INSERT INTO calculator VALUES (?,?,?,?)",c.calculatorId, c.createdAt, c.updatedAt, c.stepId];
    }
    return success;
}

-(bool)deleteDataType:(DataType)dataType withId:(NSString*)idString{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    switch (dataType) {
        case DataTypeProtocol:
            return [db executeUpdate:@"DELETE FROM protocol WHERE objectID = ", idString];
        case DataTypeStep:
            return [db executeUpdate:@"DELETE FROM step WHERE objectID = ", idString];
        case DataTypeComponent:
            return [self deleteComponentsWithObject:idString];
        case DataTypeFormComponent:
            return [self deleteFormComponentsWithObject:idString];
        default:
            break;
    }
    return NULL;
}

-(bool) deleteComponentsWithObject:(NSString*) idString{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL tb = [db executeUpdate:@"DELETE FROM textBlock WHERE objectID = ", idString];
    BOOL f = [db executeUpdate:@"DELETE FROM form WHERE objectID = ", idString];
    BOOL c = [db executeUpdate:@"DELETE FROM calculator WHERE objectID = ", idString];
    BOOL l =[db executeUpdate:@"DELETE FROM link WHERE objectID = ", idString];
    return tb && f && c && l;
}

-(bool) deleteFormComponentsWithObject: (NSString *) idString{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL fn = [db executeUpdate:@"DELETE FROM formNumber WHERE objectID = ", idString];
    BOOL fs = [db executeUpdate:@"DELETE FROM formSelection WHERE objectID = ", idString];
    return fn && fs;
}

-(id)getObjectDataType:(DataType)dataType withId:(NSString*)idString{
    NSArray *tableName = [self tableNamesForDataType:dataType];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    FMResultSet * result;
    if(success)
    {
        [db open];
        result = [db executeQuery:@"SELECT * FROM ? WHERE objectID = ?", tableName, idString];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    [db close];
    return result;
}

-(NSArray*)getAll:(DataType)dataType{
    return [self getAll:dataType withParentId:nil];
}

-(NSArray *) getAllFormComponentsWithParentID: (NSString *)parentId
{
    
    NSMutableArray *formComponents = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *fsResults;
        if(parentId)
            fsResults = [db executeQuery:@"SELECT * FROM formSelection WHERE formID = ?", parentId];
        else
            fsResults = [db executeQuery:@"SELECT * FROM formSelection"];
        while([fsResults next])
        {
            FormSelection *fs = [[FormSelection alloc]init];
            fs.formSelectionId = [fsResults stringForColumn:@"objectID"];
            fs.choiceA = [fsResults stringForColumn:@"choiceA"];
            fs.choiceB = [fsResults stringForColumn:@"choiceB"];
            fs.label = [fsResults stringForColumn:@"label"];
            fs.updatedAt = [fsResults dateForColumn:@"updatedAt"];
            fs.createdAt = [fsResults dateForColumn:@"createdAt"];
            fs.formId = [fsResults stringForColumn:@"formID"];
            [formComponents addObject:fs];
        }
        FMResultSet *fnResults;
        if(parentId)
            fnResults= [db executeQuery:@"SELECT * from formNumber WHERE formID = ?", parentId];
        else
            fnResults = [db executeQuery:@"SELECT * from formNumber"];
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
    if ([db hadError])
    {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db close];
    return formComponents;
}

-(NSArray *) getAllFormComponents
{
    return [self getAllComponentsWithParentID:nil];
}

-(NSArray*)getAllComponentsWithParentID: (NSString *) parentId
{
    NSMutableArray *components = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *tbResults;
        if(parentId)
            tbResults= [db executeQuery:@"SELECT * FROM textblock WHERE stepID = ?", parentId];
        else
            tbResults= [db executeQuery:@"SELECT * FROM textblock"];
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
        
        FMResultSet *cResults;
        if(parentId)
            cResults = [db executeQuery:@"SELECT * FROM calculator WHERE stepID = ", parentId];
        else
            cResults = [db executeQuery:@"SELECT * FROM calculator"];
        
        while([cResults next])
        {
            Calculator *c = [[Calculator alloc]init];
            c.calculatorId = [cResults stringForColumn:@"objectID"];
            c.updatedAt = [cResults dateForColumn:@"updatedAt"];
            c.createdAt = [cResults dateForColumn:@"createdAt"];
            c.stepId = [cResults stringForColumn:@"stepID"];
            [components addObject:c];
        }
        
        FMResultSet *lResults;
        if(parentId)
            lResults = [db executeQuery:@"SELECT * FROM link WHERE stepID = ?", parentId];
        else
            lResults = [db executeQuery:@"SELECT * FROM link  "];
        
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

-(NSArray*)getAllComponents
{
    return [self getAllComponentsWithParentID:nil];
}

-(NSArray*)getStepsForProtocolId:(NSString*)protocolId{
    NSMutableArray *steps = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM step WHERE protocolID = ?", protocolId];
        
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
    }
    return steps;
}

-(NSArray*)getComponentsForStepId:(NSString*)stepId{
    NSMutableArray *components = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *tbResults;
        tbResults= [db executeQuery:@"SELECT * FROM textBlock WHERE stepID = ?", stepId];
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
        FMResultSet *cResults = [db executeQuery:@"SELECT * FROM calculator  WHERE stepID = ?", stepId];
        while([tbResults next])
        {
            Calculator *c = [[Calculator alloc]init];
            c.calculatorId = [cResults stringForColumn:@"objectID"];
            c.updatedAt = [cResults dateForColumn:@"updatedAt"];
            c.createdAt = [cResults dateForColumn:@"createdAt"];
            c.stepId = [cResults stringForColumn:@"stepID"];
            [components addObject:c];
        }
        
        FMResultSet *lResults = [db executeQuery:@"SELECT * FROM link WHERE stepID = ? ", stepId];
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

-(BOOL) updateProtocol: (MedProtocol *) mp
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE protocol SET pName = '%@', updatedAt = '%@' where id = %@",mp.name, mp.updatedAt,mp.idStr]];
    [db close];
    return success;
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
