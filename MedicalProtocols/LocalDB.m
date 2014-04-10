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
        _databaseName = @"medRef.db";
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"Private Documents/MedProtocol/"];
        _databasePath = [path stringByAppendingPathComponent:_databaseName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:self.databasePath])
        {
            NSLog(@"COPYING DB FROM RESOURCES TO LIBRARY");
            NSString *fromPath = [[NSBundle mainBundle] bundlePath];
            fromPath = [fromPath stringByAppendingPathComponent:_databaseName];
            NSError *createFileError = nil;
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path  withIntermediateDirectories:YES attributes:nil error:&createFileError]) {
                NSLog(@"Error copying files: %@", [createFileError localizedDescription]);
            }
            NSError *copyError = nil;
            if (![[NSFileManager defaultManager]copyItemAtPath:fromPath toPath:_databasePath error:&copyError]) {
                NSLog(@"Error copying files: %@", [copyError localizedDescription]);
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"dbinitialized"];
            [defaults synchronize];
        }
        _dataSourceReady = YES;
    }
    return self;
}

-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(int)parentId{
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
                if(parentId == -1)
                    return NULL;
                else
                    protocolResults = [db executeQuery:@"SELECT * FROM protocol"];
                while([protocolResults next])
                {
                    MedProtocol *medProtocol = [[MedProtocol alloc]initWithName:[protocolResults stringForColumn:@"pName"] objectId:[protocolResults intForColumn:@"id"]];
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
                    stepResults = [db executeQuery:@"SELECT * FROM step WHERE protocolId = ?", parentId];
                } else {
                    stepResults = [db executeQuery:@"SELECT * FROM step"];
                }
                while([stepResults next])
                {
                    ProtocolStep *step = [[ProtocolStep alloc] initWithId:[stepResults intForColumn:@"id"] stepNumber:[stepResults intForColumn:@"stepNumber"] description:[stepResults stringForColumn:@"description"] protocolId:[stepResults intForColumn:@"protocolId"]];
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

-(bool)updateObjectWithDataType:(DataType)dataType withId:(int)objectId withObject:(id)object{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    bool success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *medProtocol = (MedProtocol*) object;
        success = [db executeUpdate:@"UPDATE protocol SET id = ?, pName = ? WHERE id = ? ",medProtocol.objectId, medProtocol.name, objectId];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *step = (ProtocolStep *)object;
        success = [db executeUpdate:@"UPDATE step SET id = ?, stepNumber = ?, protocolId = ? , description = ? WHERE id = ?", step.objectId, step.stepNumber, step.protocolId, step.description, objectId];
    }
    else if([object isKindOfClass:[Form class]])
    {
        Form* form = (Form *) object;
        success = [db executeUpdate:@"UPDATE form SET id = ?, stepId = ? WHERE id = ?", form.objectId, form.stepId, objectId];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *textBlock = (TextBlock *) object;
        success = [db executeUpdate:@"UPDATE textBlock SET id = ?, printable = ?, title = ?, stepId = ? WHERE id = ?", textBlock.objectId, textBlock.printable, textBlock.title, textBlock.stepId, objectId];
    }
    else if([object isKindOfClass:[Link class]])
    {
        Link *link = (Link *) object;
        success = [db executeUpdate:@"UPDATE link SET id = ?, url = ?, label = ?, stepId = ? WHERE id = ?", link.objectId, link.url, link.label, link.stepId, objectId];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *calculator = (Calculator*)object;
        success = [db executeUpdate:@"UPDATE calculator SET id = ?, stepId = ? WHERE id = ?", calculator.objectId, calculator.stepId, objectId];
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        FormNumber *formNumber = (FormNumber*)object;
        success = [db executeUpdate:@"UPDATE formNumber SET id = ?, stepId = ? WHERE id = ?", formNumber.objectId, formNumber.formId, objectId];
    }
    else if([object isKindOfClass:[FormSelection class]])
    {
        FormSelection *formSelection = (FormSelection*)object;
        success = [db executeUpdate:@"UPDATE formSelection SET id = ?, stepId = ? WHERE id = ?", formSelection.objectId, formSelection.formId, objectId];
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
        success =  [db executeUpdate:@"INSERT INTO protocol (objectId, pName) VALUES (:objectId,:pName)", [NSNumber numberWithInt:medProtocol.objectId], medProtocol.name];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *step = (ProtocolStep*)object;
        success =  [db executeUpdate:@"INSERT INTO step (objectId, stepNumber, protocolId, description) VALUES (:objectId,:stepNumber,:protocolId,:description)",[NSNumber numberWithInt:step.objectId], [NSNumber numberWithInt:step.stepNumber], [NSNumber numberWithInt:step.protocolId], step.description];
    }
    
    else if([object isKindOfClass:[Form class]])
    {
        Form *form = (Form *) object;
        success = [db executeUpdate:@"INSERT INTO form (objectId, stepId) VALUES (:objectId,:stepId)", [NSNumber numberWithInt:form.objectId], [NSNumber numberWithInt:form.stepId]];
    }
    
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *textBlock = (TextBlock *) object;
        success = [db executeUpdate:@"INSERT INTO textBlock (objectId,printable,title,stepId,content) VALUES (:objectId,:printable,:title,:stepId,:content)", [NSNumber numberWithInt:textBlock.objectId], [NSNumber numberWithBool:textBlock.printable], textBlock.title, [NSNumber numberWithInt:textBlock.stepId],textBlock.content];
    }
    
    else if([object isKindOfClass:[Link class]])
    {
        Link *link = (Link *)object;
        success = [db executeUpdate:@"INSERT INTO link (objectId,url,label,stepId) VALUES (:objectId,:url,:label,:stepId)", [NSNumber numberWithInt:link.objectId], link.url, link.label, [NSNumber numberWithInt:link.stepId]];
    }
    
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *calculator = (Calculator *)object;
        success = [db executeUpdate:@"INSERT INTO calculator (objectId,stepId) VALUES (:objectId,:stepId)",[NSNumber numberWithInt:calculator.objectId], [NSNumber numberWithInt:calculator.stepId]];
    }
    else if([object isKindOfClass:[FormSelection class]])
    {
        FormSelection *formSelection = (FormSelection *)object;
        success = [db executeUpdate:@"INSERT INTO formSelection (objectId,choiceA,choiceB,label,formId) VALUES (:objectId,:choiceA,:choiceB,:label,:formId)",[NSNumber numberWithInt:formSelection.objectId], formSelection.choiceA, formSelection.choiceB, formSelection.label, [NSNumber numberWithInt:formSelection.formId]];
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        FormNumber *formNumber = (FormNumber *)object;
        success = [db executeUpdate:@"INSERT INTO formNumber (objectId,defaultValue,minValue,maxValue,label,formId) VALUES (:objectId,:defaultValue,:minValue,:maxValue,:label,:formId)",[NSNumber numberWithInt:formNumber.objectId], [NSNumber numberWithInt:formNumber.defaultValue],[NSNumber numberWithInt:formNumber.minValue],[NSNumber numberWithInt:formNumber.maxValue],formNumber.label,[NSNumber numberWithInt:formNumber.formId]];
    }
    return success;
}

-(bool)deleteObjectWithDataType:(DataType)dataType withId:(int)objectId{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    bool protocol = NO, step = NO, textBlock = NO, link = NO, form = NO, calculator = NO, formNumber = NO, formSelection = NO;
    
    switch (dataType) {
        case DataTypeProtocol:
            [self deleteObjectWithDataType:DataTypeStep withId:objectId]; //recursive call to delete steps associated with this particular protocol
            protocol = [db executeUpdate:@"DELETE FROM protocol WHERE id = ?", objectId];
        case DataTypeStep:
            [self deleteObjectWithDataType:DataTypeComponent withId:objectId];//recursive call to delete components associated with this particular step
            step = [db executeUpdate:@"DELETE FROM step WHERE id = ?", objectId];
        case DataTypeComponent:
            [self deleteObjectWithDataType:DataTypeFormComponent withId:objectId];//recursive call to delete formComponents associated with this particular form
            textBlock = [db executeUpdate:@"DELETE FROM textBlock WHERE stepId = ?", objectId];
            form = [db executeUpdate:@"DELETE FROM form WHERE stepId = ?", objectId];
            link = [db executeUpdate:@"DELETE FROM link WHERE stepId = ?", objectId];
            calculator = [db executeUpdate:@"DELETE FROM calculator WHERE stepId = ?", objectId];
        case DataTypeFormComponent:
            formNumber = [db executeUpdate:@"DELETE FROM formNumber WHERE formId = ?", objectId];
            formSelection = [db executeUpdate:@"DELETE FROM formSelection WHERE formId = ?", objectId];
        default:
            break;
    }
    return protocol || step || textBlock || link || form || calculator || formNumber || formSelection;
}

-(id)getObjectWithDataType:(DataType)dataType withId:(int)objectId{
    NSArray *tableName = [self tableNamesForDataType:dataType];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    FMResultSet * result;
    if(success)
    {
        [db open];
        result = [db executeQuery:@"SELECT * FROM ? WHERE id = ?", tableName, objectId];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    [db close];
    return result;
}

-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    return [self getAllObjectsWithDataType:dataType withParentId:-1];
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
            formSelectionResults = [db executeQuery:@"SELECT * FROM formSelection WHERE formId = ?", parentId];
        else
            formSelectionResults = [db executeQuery:@"SELECT * FROM formSelection"];
        while([formSelectionResults next])
        {
            FormSelection *formSelection = [[FormSelection alloc] initWithLabel:[formSelectionResults stringForColumn:@"label"] choiceA:[formSelectionResults stringForColumn:@"choiceA"] choiceB:[formSelectionResults stringForColumn:@"choiceB"] objectId:[formSelectionResults intForColumn:@"id"] formId:[formSelectionResults intForColumn:@"formId"]];
            [formComponents addObject:formSelection];
        }
        FMResultSet *formNumberResults;
        if(parentId)
            formNumberResults= [db executeQuery:@"SELECT * from formNumber WHERE formId = ?", parentId];
        else
            formNumberResults = [db executeQuery:@"SELECT * from formNumber"];
        while ([formNumberResults next]) {
            FormNumber *formNumber = [[FormNumber alloc] initWithLabel:[formNumberResults stringForColumn:@"label"] defaultValue:[formNumberResults intForColumn:@"defaultValue"] minValue:[formNumberResults intForColumn:@"minValue"] maxValue:[formNumberResults intForColumn:@"maxValue"] objectId:[formNumberResults intForColumn:@"id"] formId:[formNumberResults intForColumn:@"formId"]];
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
    return [self getAllComponentsWithParentID:-1];
}

-(NSArray*)getAllComponentsWithParentID: (int) parentId
{
    NSMutableArray *components = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        [db open];
        FMResultSet *textBlockResults;
        if(parentId == -1)
            textBlockResults= [db executeQuery:@"SELECT * FROM textblock WHERE stepId = ?", parentId];
        else
            textBlockResults = [db executeQuery:@"SELECT * FROM textblock"];
        while([textBlockResults next])
        {
            TextBlock *textBlock = [[TextBlock alloc] initWithTitle:[textBlockResults stringForColumn:@"title"] content:[textBlockResults stringForColumn:@"content"] printable:[textBlockResults boolForColumn:@"printable"] objectId:[textBlockResults intForColumn:@"id"] stepId:[textBlockResults intForColumn:@"stepId"]];
            [components addObject:textBlock];
        }
        
        FMResultSet *calculatorResults;
        if(parentId == -1)
            calculatorResults = [db executeQuery:@"SELECT * FROM calculator WHERE stepId = ?", parentId];
        else
            calculatorResults = [db executeQuery:@"SELECT * FROM calculator"];
        
        while([calculatorResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[calculatorResults intForColumn:@"id"] stepId:[calculatorResults intForColumn:@"stepId"]];
            [components addObject:calculator];
        }
        
        FMResultSet *linkResults;
        if(parentId)
            linkResults = [db executeQuery:@"SELECT * FROM link WHERE stepId = ?", parentId];
        else
            linkResults = [db executeQuery:@"SELECT * FROM link  "];
        
        while([linkResults next])
        {
            Link *link = [[Link alloc] initWithLabel:[linkResults stringForColumn:@"label"] url:[linkResults stringForColumn:@"url"] objectId:[linkResults intForColumn:@"id"] stepId:[linkResults intForColumn:@"stepId"]];
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
    return [self getAllComponentsWithParentID:-1];
}

-(NSArray*)getStepsForProtocolId:(NSString*)protocolId{
    NSMutableArray *steps = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM step WHERE protocolId = ?", protocolId];
        
        while([results next])
        {
            ProtocolStep *step = [[ProtocolStep alloc] initWithId:[results intForColumn:@"id"] stepNumber:[results intForColumn:@"stepNumber"] description:[results stringForColumn:@"description"] protocolId:[results intForColumn:@"protocolId"]];
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
        textBlockResults= [db executeQuery:@"SELECT * FROM textBlock WHERE stepId = ?", stepId];
        while([textBlockResults next])
        {
            TextBlock *t = [[TextBlock alloc] initWithTitle:[textBlockResults stringForColumn:@"title"] content:[textBlockResults stringForColumn:@"content"] printable:[textBlockResults boolForColumn:@"printable"] objectId:[textBlockResults intForColumn:@"id"] stepId:[textBlockResults intForColumn:@"stepId"]];
            [components addObject:t];
        }
        FMResultSet *calculatorResults = [db executeQuery:@"SELECT * FROM calculator  WHERE stepId = ?", stepId];
        while([textBlockResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[calculatorResults intForColumn:@"id"] stepId:[calculatorResults intForColumn:@"stepId"]];
            [components addObject:calculator];
        }
        
        FMResultSet *linkResults = [db executeQuery:@"SELECT * FROM link WHERE stepId = ? ", stepId];
        while([linkResults next])
        {
            Link *link = [[Link alloc] initWithLabel:[linkResults stringForColumn:@"label"] url:[linkResults stringForColumn:@"url"] objectId:[linkResults intForColumn:@"id"] stepId:[linkResults intForColumn:@"stepId"]];
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
