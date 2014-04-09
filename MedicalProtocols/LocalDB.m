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

@interface LocalDB()
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;
-(NSArray*)tableNamesForDataType:(DataType)dataType;
@end

@implementation LocalDB
+(LocalDB *) sharedInstance{
    return [LocalDB sharedInstanceWithDelegate:nil];
}
+(LocalDB *) sharedInstanceWithDelegate:(id<LocalDBReadyForUseDelegate>)delegate;
{
    static LocalDB* sharedObject = nil;
    if(sharedObject == nil){
        sharedObject = [[LocalDB alloc] init];
        sharedObject.delegate = delegate;
    }
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
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    switch (dataType) {
        case DataTypeProtocol:
            if(success)
            {
                [db open];
                NSMutableArray *protocols = [[NSMutableArray alloc]init];
                FMResultSet *protocolResults;
                if(parentId)
                    return NULL;
                else
                    protocolResults = [db executeQuery:@"SELECT * FROM protocol"];
                while([protocolResults next])
                {
                    MedProtocol *medProtocol = [[MedProtocol alloc]initWithName:[protocolResults stringForColumn:@"pName"] objectId:[protocolResults intForColumn:@"objectId"]];
                        [protocols addObject:medProtocol];
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
                FMResultSet *stepResults;
                if(parentId){
                    stepResults = [db executeQuery:@"SELECT * FROM step WHERE protocolID = ?", parentId];
                } else {
                    stepResults = [db executeQuery:@"SELECT * FROM step"];
                }
                while([stepResults next])
                {
                    ProtocolStep *step = [[ProtocolStep alloc] initWithId:[stepResults intForColumn:@"objectId"] stepNumber:[stepResults intForColumn:@"stepNumber"] description:[stepResults stringForColumn:@"description"] protocolId:[stepResults intForColumn:@"protocolId"]];
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
    bool success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *medProtocol = (MedProtocol*) object;
        success = [db executeUpdate:@"UPDATE protocol SET objectID = ?, pName = ? WHERE objectID = ? ",medProtocol.objectId, medProtocol.name, idString];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *step = (ProtocolStep *)object;
        success = [db executeUpdate:@"UPDATE step SET objectID = ?, stepNumber = ?, protocolID = ? , description = ? WHERE objectID = ?", step.objectId, step.stepNumber, step.updatedAt, step.protocolId, step.description, idString];
    }
    else if([object isKindOfClass:[Form class]])
    {
        Form* form = (Form *) object;
        success = [db executeUpdate:@"UPDATE form SET objectID = ?, stepID = ? WHERE objectID = ?", form.objectId, form.updatedAt, form.stepId, idString];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *textBlock = (TextBlock *) object;
        success = [db executeUpdate:@"UPDATE textBlock SET objectID = ?, printable = ?, title = ?, stepID = ? WHERE objectID = ?", textBlock.objectId, textBlock.printable, textBlock.stepId, idString];
    }
    else if([object isKindOfClass:[Link class]])
    {
        Link *link = (Link *) object;
        success = [db executeUpdate:@"UPDATE link SET objectID = ?, url = ?,, printable = ?, label = ?, stepID = ? WHERE objectID = ?", link.objectId, link.url, link.printable, link.label, link.stepId, idString];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *calculator = (Calculator*)object;
        success = [db executeUpdate:@"UPDATE calculator SET objectID = ?, stepID = ? WHERE objectID = ?", calculator.objectId, calculator.stepId, idString];
    }
    return success;
}

-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    bool success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *medProtocol = (MedProtocol *)object;
        success =  [db executeUpdate:@"INSERT INTO protocol VALUES (?,?,?)", medProtocol.objectId, medProtocol.name];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *step = (ProtocolStep*)object;
        success =  [db executeUpdate:@"INSERT INTO step VALUES (?,?,?,?,?)",step.objectId, step.stepNumber, step.updatedAt, step.protocolId, step.description];
    }
    
    else if([object isKindOfClass:[Form class]])
    {
        Form *form = (Form *) object;
        success = [db executeUpdate:@"INSERT INTO form VALUES (?,?,?)", form.objectId, form.updatedAt, form.stepId];
    }
    
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *textBlock = (TextBlock *) object;
        success = [db executeUpdate:@"INSERT INTO textBlock VALUES (?,?,?,?)", textBlock.objectId, textBlock.printable, textBlock.title, textBlock.stepId];
    }
    
    else if([object isKindOfClass:[Link class]])
    {
        Link *link = (Link *)object;
        success = [db executeUpdate:@"INSERT INTO link VALUES (?,?,?,?,?)", link.objectId, link.url, link.printable, link.label, link.stepId];
    }
    
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *calculator = (Calculator *)object;
        success = [db executeUpdate:@"INSERT INTO calculator VALUES (?,?)",calculator.objectId, calculator.stepId];
    }
    return success;
}

-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    bool protocol = NO, step = NO, textBlock = NO, link = NO, form = NO, calculator = NO, formNumber = NO, formSelection = NO;
    
    switch (dataType) {
        case DataTypeProtocol:
            [self deleteObjectWithDataType:DataTypeStep withId:idString]; //recursive call to delete steps associated with this particular protocol
            protocol = [db executeUpdate:@"DELETE FROM protocol WHERE objectID = ?", idString];
        case DataTypeStep:
            [self deleteObjectWithDataType:DataTypeComponent withId:idString];//recursive call to delete components associated with this particular step
            step = [db executeUpdate:@"DELETE FROM step WHERE objectID = ?", idString];
        case DataTypeComponent:
            [self deleteObjectWithDataType:DataTypeFormComponent withId:idString];//recursive call to delete formComponents associated with this particular form
            textBlock = [db executeUpdate:@"DELETE FROM textBlock WHERE stepID = ?", idString];
            form = [db executeUpdate:@"DELETE FROM form WHERE stepID = ?", idString];
            link = [db executeUpdate:@"DELETE FROM link WHERE stepID = ?", idString];
            calculator = [db executeUpdate:@"DELETE FROM calculator WHERE stepID = ?", idString];
        case DataTypeFormComponent:
            formNumber = [db executeUpdate:@"DELETE FROM formNumber WHERE formID = ?", idString];
            formSelection = [db executeUpdate:@"DELETE FROM formSelection WHERE formId = ?", idString];
        default:
            break;
    }
    return protocol || step || textBlock || link || form || calculator || formNumber || formSelection;
}

-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    NSArray *tableName = [self tableNamesForDataType:dataType];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool success = [fileManager fileExistsAtPath:self.databasePath];
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
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *formSelectionResults;
        if(parentId)
            formSelectionResults = [db executeQuery:@"SELECT * FROM formSelection WHERE formID = ?", parentId];
        else
            formSelectionResults = [db executeQuery:@"SELECT * FROM formSelection"];
        while([formSelectionResults next])
        {
            FormSelection *formSelection = [[FormSelection alloc] initWithLabel:[formSelectionResults stringForColumn:@"label"] choiceA:[formSelectionResults stringForColumn:@"choiceA"] choiceB:[formSelectionResults stringForColumn:@"choiceB"] objectId:[formSelectionResults intForColumn:@"objectID"] formId:[formSelectionResults intForColumn:@"formID"]];
            [formComponents addObject:formSelection];
        }
        FMResultSet *formNumberResults;
        if(parentId)
            formNumberResults= [db executeQuery:@"SELECT * from formNumber WHERE formID = ?", parentId];
        else
            formNumberResults = [db executeQuery:@"SELECT * from formNumber"];
        while ([formNumberResults next]) {
            FormNumber *formNumber = [[FormNumber alloc] initWithLabel:[formNumberResults stringForColumn:@"label"] defaultValue:[formNumberResults intForColumn:@"defaultValue"] minValue:[formNumberResults intForColumn:@"minValue"] maxValue:[formNumberResults intForColumn:@"maxValue"] objectId:[formNumberResults intForColumn:@"objectID"] formId:[formNumberResults intForColumn:@"formID"]];
            [formComponents addObject:formNumber];
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
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *textBlockResults;
        if(parentId)
            textBlockResults= [db executeQuery:@"SELECT * FROM textblock WHERE stepID = ?", parentId];
        else
            textBlockResults = [db executeQuery:@"SELECT * FROM textblock"];
        while([textBlockResults next])
        {
            TextBlock *textBlock = [[TextBlock alloc] initWithTitle:[textBlockResults stringForColumn:@"title"] content:[textBlockResults stringForColumn:@"content"] printable:[textBlockResults boolForColumn:@"printable"] objectId:[textBlockResults intForColumn:@"objectID"] stepId:[textBlockResults intForColumn:@"stepID"]];
            [components addObject:textBlock];
        }
        
        FMResultSet *calculatorResults;
        if(parentId)
            calculatorResults = [db executeQuery:@"SELECT * FROM calculator WHERE stepID = ", parentId];
        else
            calculatorResults = [db executeQuery:@"SELECT * FROM calculator"];
        
        while([calculatorResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[calculatorResults intForColumn:@"objectID"] stepId:[calculatorResults intForColumn:@"stepID"]];
            [components addObject:calculator];
        }
        
        FMResultSet *linkResults;
        if(parentId)
            linkResults = [db executeQuery:@"SELECT * FROM link WHERE stepID = ?", parentId];
        else
            linkResults = [db executeQuery:@"SELECT * FROM link  "];
        
        while([linkResults next])
        {
            Link *link = [[Link alloc] initWithLabel:[linkResults stringForColumn:@"label"] url:[linkResults stringForColumn:@"url"] objectId:[linkResults intForColumn:@"objectId"] stepId:[linkResults intForColumn:@"stepId"]];
            [components addObject:link];
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
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM step WHERE protocolID = ?", protocolId];
        
        while([results next])
        {
            ProtocolStep *step = [[ProtocolStep alloc] initWithId:[results intForColumn:@"objectId"] stepNumber:[results intForColumn:@"stepNumber"] description:[results stringForColumn:@"description"] protocolId:[results intForColumn:@"protocolId"]];
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
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *textBlockResults;
        textBlockResults= [db executeQuery:@"SELECT * FROM textBlock WHERE stepID = ?", stepId];
        while([textBlockResults next])
        {
            TextBlock *t = [[TextBlock alloc] initWithTitle:[textBlockResults stringForColumn:@"title"] content:[textBlockResults stringForColumn:@"content"] printable:[textBlockResults boolForColumn:@"printable"] objectId:[textBlockResults intForColumn:@"objectId"] stepId:[textBlockResults intForColumn:@"stepId"]];
            [components addObject:t];
        }
        FMResultSet *calculatorResults = [db executeQuery:@"SELECT * FROM calculator  WHERE stepID = ?", stepId];
        while([textBlockResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[calculatorResults intForColumn:@"objectId"] stepId:[calculatorResults intForColumn:@"stepId"]];
            [components addObject:calculator];
        }
        
        FMResultSet *linkResults = [db executeQuery:@"SELECT * FROM link WHERE stepID = ? ", stepId];
        while([linkResults next])
        {
            Link *link = [[Link alloc] initWithLabel:[linkResults stringForColumn:@"label"] url:[linkResults stringForColumn:@"url"] objectId:[linkResults intForColumn:@"objectId"] stepId:[linkResults intForColumn:@"stepId"]];
            [components addObject:link];
        }
        if ([db hadError]) {
            NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db close];
    }
    return components;
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
