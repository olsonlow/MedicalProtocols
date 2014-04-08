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
+(LocalDB *) sharedInstance
{
    static LocalDB* sharedObject = nil;
    if(sharedObject == nil)
        sharedObject = [[LocalDB alloc] init];
    return sharedObject;
}
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
        if(![fileManager fileExistsAtPath:self.databasePath])
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

-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(NSString*)parentId{
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
                    MedProtocol *mp = [[MedProtocol alloc]initWithName:[results stringForColumn:@"pName"] objectId:[results stringForColumn:@"objectID"]];
//                    mp.updatedAt = [results dateForColumn:@"updatedAt"];
//                    mp.createdAt = [results dateForColumn:@"createdAt"];
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
                    ProtocolStep *step = [[ProtocolStep alloc] initWithId:[results stringForColumn:@"objectID"] stepNumber:[results intForColumn:@"stepNumber"] description:[results stringForColumn:@"description"] protocolId:[results stringForColumn:@"protocolID"]];
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

-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *mp = (MedProtocol*) object;
        success = [db executeUpdate:@"UPDATE protocol SET objectID = ?, pName = ?, createdAt = ?, updatedAt = ? WHERE objectID = ? ",mp.objectId, mp.name, mp.createdAt, mp.updatedAt, idString];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *ps = (ProtocolStep *)object;
        success = [db executeUpdate:@"UPDATE step SET objectID = ?, stepNumber = ?, createdAt = ?, updatedAt = ?, protocolID = ? , description = ? WHERE objectID = ?", ps.objectId, ps.stepNumber, ps.createdAt, ps.updatedAt, ps.protocolId, ps.description, idString];
    }
    else if([object isKindOfClass:[Form class]])
    {
        Form* form = (Form *) object;
        success = [db executeUpdate:@"UPDATE form SET objectID = ?, createdAt = ?, updatedAt = ?, stepID = ? WHERE objectID = ?", form.objectId, form.createdAt, form.updatedAt, form.stepId, idString];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *textBlock = (TextBlock *) object;
        success = [db executeUpdate:@"UPDATE textBlock SET objectID = ?, createdAt = ?, updatedAt = ?, printable = ?, title = ?, stepID = ? WHERE objectID = ?", textBlock.objectId, textBlock.createdAt, textBlock.updatedAt, textBlock.printable, textBlock.stepId, idString];
    }
    else if([object isKindOfClass:[Link class]])
    {
        Link *link = (Link *) object;
        success = [db executeUpdate:@"UPDATE link SET objectID = ?, url = ?, createdAt = ?, updatedAt = ?, printable = ?, label = ?, stepID = ? WHERE objectID = ?", link.objectId, link.url, link.createdAt, link.updatedAt, link.printable, link.label, link.stepId, idString];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *calculator = (Calculator*)object;
        success = [db executeUpdate:@"UPDATE calculator SET objectID = ?, createdAt = ?, updatedAt = ?, stepID = ? WHERE objectID = ?", calculator.objectId, calculator.createdAt, calculator.updatedAt, calculator.stepId, idString];
    }
    return success;
}

-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *mp = (MedProtocol *)object;
        success =  [db executeUpdate:@"INSERT INTO protocol VALUES (?,?,?,?)", mp.objectId, mp.name,  mp.createdAt, mp.updatedAt];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *ps = (ProtocolStep*)object;
        success =  [db executeUpdate:@"INSERT INTO step VALUES (?,?,?,?,?,?)",ps.objectId, ps.stepNumber, ps.createdAt, ps.updatedAt, ps.protocolId, ps.description];
    }
    
    else if([object isKindOfClass:[Form class]])
    {
        Form *form = (Form *) object;
        success = [db executeUpdate:@"INSERT INTO form VALUES (?,?,?,?)", form.objectId, form.createdAt, form.updatedAt, form.stepId];
    }
    
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *tb = (TextBlock *) object;
        success = [db executeUpdate:@"INSERT INTO textBlock VALUES (?,?,?,?,?,?)", tb.objectId, tb.createdAt, tb.updatedAt, tb.printable, tb.title, tb.stepId];
    }
    
    else if([object isKindOfClass:[Link class]])
    {
        Link *l = (Link *)object;
        success = [db executeUpdate:@"INSERT INTO link VALUES (?,?,?,?,?,?,?)", l.objectId, l.url, l.createdAt, l.updatedAt, l.printable, l.label, l.stepId];
    }
    
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *c = (Calculator *)object;
        success = [db executeUpdate:@"INSERT INTO calculator VALUES (?,?,?,?)",c.objectId, c.createdAt, c.updatedAt, c.stepId];
    }
    return success;
}

-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    switch (dataType) {
        case DataTypeProtocol:
            return [db executeUpdate:@"DELETE FROM protocol WHERE objectID = ?", idString];
        case DataTypeStep:
            return [db executeUpdate:@"DELETE FROM step WHERE objectID = ?", idString];
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
    BOOL textBlock = [db executeUpdate:@"DELETE FROM textBlock WHERE objectID = ?", idString];
    BOOL form = [db executeUpdate:@"DELETE FROM form WHERE objectID = ?", idString];
   
    BOOL calculator = [db executeUpdate:@"DELETE FROM calculator WHERE objectID = ?", idString];
    BOOL link =[db executeUpdate:@"DELETE FROM link WHERE objectID = ?", idString];
    return textBlock || form || calculator || link;
}

-(bool) deleteFormComponentsWithObject: (NSString *) idString{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL fn = [db executeUpdate:@"DELETE FROM formNumber WHERE objectID = ", idString];
    BOOL fs = [db executeUpdate:@"DELETE FROM formSelection WHERE objectID = ", idString];
    return fn && fs;
}

-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
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

-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    return [self getAllObjectsWithDataType:dataType withParentId:nil];
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
            FormSelection *fs = [[FormSelection alloc] initWithLabel:[fsResults stringForColumn:@"label"] choiceA:[fsResults stringForColumn:@"choiceA"] choiceB:[fsResults stringForColumn:@"choiceB"] objectId:[fsResults stringForColumn:@"objectID"] formId:[fsResults stringForColumn:@"formID"]];
            [formComponents addObject:fs];
        }
        FMResultSet *fnResults;
        if(parentId)
            fnResults= [db executeQuery:@"SELECT * from formNumber WHERE formID = ?", parentId];
        else
            fnResults = [db executeQuery:@"SELECT * from formNumber"];
        while ([fnResults next]) {
            FormNumber *fn = [[FormNumber alloc] initWithLabel:[fnResults stringForColumn:@"label"] defaultValue:[fnResults intForColumn:@"defaultValue"] minValue:[fnResults intForColumn:@"minValue"] maxValue:[fnResults intForColumn:@"maxValue"] objectId:[fnResults stringForColumn:@"objectID"] formId:[fnResults stringForColumn:@"formID"]];
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
        FMResultSet *results;
        if(parentId)
            results= [db executeQuery:@"SELECT * FROM textblock WHERE stepID = ?", parentId];
        else
            results = [db executeQuery:@"SELECT * FROM textblock"];
        while([results next])
        {
            TextBlock *textBlock = [[TextBlock alloc] initWithTitle:[results stringForColumn:@"title"] content:[results stringForColumn:@"content"] printable:[results boolForColumn:@"printable"] objectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
            [components addObject:textBlock];
        }
        
        FMResultSet *cResults;
        if(parentId)
            cResults = [db executeQuery:@"SELECT * FROM calculator WHERE stepID = ", parentId];
        else
            cResults = [db executeQuery:@"SELECT * FROM calculator"];
        
        while([cResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[cResults stringForColumn:@"objectID"] stepId:[cResults stringForColumn:@"stepID"]];
            [components addObject:calculator];
        }
        
        FMResultSet *lResults;
        if(parentId)
            lResults = [db executeQuery:@"SELECT * FROM link WHERE stepID = ?", parentId];
        else
            lResults = [db executeQuery:@"SELECT * FROM link  "];
        
        while([lResults next])
        {
            Link *l = [[Link alloc] initWithLabel:[lResults stringForColumn:@"label"] url:[lResults stringForColumn:@"url"] objectId:[lResults stringForColumn:@"objectID"] stepId:[lResults stringForColumn:@"stepID"]];
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
            ProtocolStep *step = [[ProtocolStep alloc] initWithId:[results stringForColumn:@"objectID"] stepNumber:[results intForColumn:@"stepNumber"] description:[results stringForColumn:@"description"] protocolId:[results stringForColumn:@"protocolID"]];
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
            TextBlock *t = [[TextBlock alloc] initWithTitle:[tbResults stringForColumn:@"title"] content:[tbResults stringForColumn:@"content"] printable:[tbResults boolForColumn:@"printable"] objectId:[tbResults stringForColumn:@"objectID"] stepId:[tbResults stringForColumn:@"stepID"]];
            [components addObject:t];
        }
        FMResultSet *cResults = [db executeQuery:@"SELECT * FROM calculator  WHERE stepID = ?", stepId];
        while([tbResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[cResults stringForColumn:@"objectID"] stepId:[cResults stringForColumn:@"stepID"]];
            [components addObject:calculator];
        }
        
        FMResultSet *lResults = [db executeQuery:@"SELECT * FROM link WHERE stepID = ? ", stepId];
        while([lResults next])
        {
            Link *link = [[Link alloc] initWithLabel:[lResults stringForColumn:@"label"] url:[lResults stringForColumn:@"url"] objectId:[lResults stringForColumn:@"objectID"] stepId:[lResults stringForColumn:@"stepID"]];
            [components addObject:link];
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
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE protocol SET pName = '%@', updatedAt = '%@' where id = %@",mp.name, mp.updatedAt,mp.objectId]];
    [db close];
    return success;
}

-(NSString *) tableNameForObject:(id) object
{
    NSString *className = nil;
    if([object isKindOfClass:[MedProtocol class]])
    {
        className = @"MedProtocol";
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        className = @"ProtocolStep";
    }
    else if([object isKindOfClass:[Link class]])
    {
        className = @"Link";
    }
    else if([object isKindOfClass:[Form class]])
    {
        className = @"Form";
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        className = @"Calculator";
    }
    return className;
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
