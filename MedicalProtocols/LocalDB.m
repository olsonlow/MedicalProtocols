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
@property(nonatomic,assign,readwrite) bool dataSourceReady;
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
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"dbinitialized"];
        [defaults synchronize];
        _dataSourceReady = YES;
    }
    return self;
}

-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    return [self getAllObjectsWithDataType:dataType withParentId:NULL];
}

-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)objectId{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    FMResultSet * result;
    if(success)
    {
        [db open];
        switch (dataType) {
            case DataTypeProtocol:
                result = [db executeQuery:@"SELECT * FROM protocol WHERE objectId = (:objectId)", objectId];
                break;
            case DataTypeStep:
                result = [db executeQuery:@"SELECT * FROM step WHERE objectId = (:objectId)", objectId];
                break;
            case DataTypeComponent:
                result = [db executeQuery:@"SELECT * FROM textBlock, calculator, form, link WHERE textBlock.objectId = calculator.objectId = form.objectId = link.objectId = (:objectId)", objectId];
            case DataTypeFormComponent:
                result = [db executeQuery:@"SELECT * FROM formNumber, formSelection WHERE formNumber.objectId = formSelection.objectId = (:objectId)", objectId];
            default:
                break;
        }
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    [db close];
    return result;
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
                protocolResults = [db executeQuery:@"SELECT * FROM protocol"];
                while([protocolResults next])
                {
                    MedProtocol *medProtocol = [[MedProtocol alloc]initWithName:[protocolResults stringForColumn:@"pName"] objectId:[protocolResults stringForColumn:@"objectId"]];
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
                    ProtocolStep *step = [[ProtocolStep alloc] initWithId:[stepResults stringForColumn:@"objectId"] orderNumber:[stepResults intForColumn:@"orderNumber"] description:[stepResults stringForColumn:@"description"] protocolId:[stepResults stringForColumn:@"protocolId"]];
                    [steps addObject:step];
                }
                if ([db hadError]) {
                    NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
                [db close];
                return steps;
            }
        case DataTypeComponent:
            return[self getAllComponentsWithParentID:parentId];
        case DataTypeFormComponent:
            return[self getAllFormComponentsWithParentID:parentId];
        default:
            break;
    }
    return NULL;
}

-(NSArray*)getAllComponents
{
    return [self getAllComponentsWithParentID:NULL];
}

-(NSArray*)getAllComponentsWithParentID: (NSString*) parentId
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
            textBlockResults= [db executeQuery:@"SELECT * FROM textblock WHERE stepId = (:stepId)", parentId];
        else
            textBlockResults = [db executeQuery:@"SELECT * FROM textblock"];
        while([textBlockResults next])
        {
            TextBlock *textBlock = [[TextBlock alloc] initWithTitle:[textBlockResults stringForColumn:@"title"] content:[textBlockResults stringForColumn:@"content"] printable:[textBlockResults boolForColumn:@"printable"] objectId:[textBlockResults stringForColumn:@"objectId"] stepId:[textBlockResults stringForColumn:@"stepId"] orderNumber:[textBlockResults intForColumn:@"orderNumber"]];
            [components addObject:textBlock];
        }
        
        FMResultSet *calculatorResults;
        if(parentId)
            calculatorResults = [db executeQuery:@"SELECT * FROM calculator WHERE stepId = (:stepId)", parentId];
        else
            calculatorResults = [db executeQuery:@"SELECT * FROM calculator"];
        
        while([calculatorResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[calculatorResults stringForColumn:@"objectId"] stepId:[calculatorResults stringForColumn:@"stepId"] orderNumber:[calculatorResults intForColumn:@"orderNumber"]];
            [components addObject:calculator];
        }
        
        FMResultSet *linkResults;
        if(parentId)
            linkResults = [db executeQuery:@"SELECT * FROM link WHERE stepId = (:stepId)", parentId];
        else
            linkResults = [db executeQuery:@"SELECT * FROM link"];
        
        while([linkResults next])
        {
            Link *link = [[Link alloc] initWithLabel:[linkResults stringForColumn:@"label"] url:[linkResults stringForColumn:@"url"] objectId:[linkResults stringForColumn:@"objectId"] stepId:[linkResults stringForColumn:@"stepId"] orderNumber:[linkResults intForColumn:@"orderNumber"]];
            [components addObject:link];
        }
        if ([db hadError]) {
            NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
        FMResultSet *formResults;
        if(parentId)
            formResults = [db executeQuery:@"SELECT * FROM form WHERE stepId = (:stepId)", parentId];
        else
            formResults = [db executeQuery:@"SELECT * FROM form"];
        
        while([formResults next])
        {
            Form *form = [[Form alloc] initWithObjectId:[formResults stringForColumn:@"objectId"] stepId:[formResults stringForColumn:@"stepId"] orderNumber:[formResults intForColumn:@"orderNumber"]];
            [components addObject:form];
        }
        if ([db hadError]) {
            NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
        [db close];
    }
    return components;
}

-(NSArray *) getAllFormComponents
{
    return [self getAllComponentsWithParentID:NULL];
}

-(NSArray *) getAllFormComponentsWithParentID: (NSString*)parentId
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
            formSelectionResults = [db executeQuery:@"SELECT * FROM formSelection WHERE formId = (:formId)", parentId];
        else
            formSelectionResults = [db executeQuery:@"SELECT * FROM formSelection"];
        while([formSelectionResults next])
        {
            FormSelection *formSelection = [[FormSelection alloc] initWithLabel:[formSelectionResults stringForColumn:@"label"] choiceA:[formSelectionResults stringForColumn:@"choiceA"] choiceB:[formSelectionResults stringForColumn:@"choiceB"] objectId:[formSelectionResults stringForColumn:@"objectId"] orderNumber:[formSelectionResults intForColumn:@"orderNumber"] formId:[formSelectionResults stringForColumn:@"formId"]];
            [formComponents addObject:formSelection];
        }
        FMResultSet *formNumberResults;
        if(parentId)
            formNumberResults= [db executeQuery:@"SELECT * from formNumber WHERE formId = (:formId)", parentId];
        else
            formNumberResults = [db executeQuery:@"SELECT * from formNumber"];
        while ([formNumberResults next]) {
            FormNumber *formNumber = [[FormNumber alloc] initWithLabel:[formNumberResults stringForColumn:@"label"] defaultValue:[formNumberResults intForColumn:@"defaultValue"] minValue:[formNumberResults intForColumn:@"minValue"] maxValue:[formNumberResults intForColumn:@"maxValue"] objectId:[formNumberResults stringForColumn:@"objectId"] orderNumber:[formNumberResults intForColumn:@"orderNumber"] formId:[formNumberResults stringForColumn:@"formId"]];
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

-(NSArray*)getStepsForProtocolId:(NSString*)protocolId{
    NSMutableArray *steps = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM step WHERE protocolId = (:protocolId)", protocolId];
        
        while([results next])
        {
            ProtocolStep *step = [[ProtocolStep alloc] initWithId:[results stringForColumn:@"objectId"] orderNumber:[results intForColumn:@"orderNumber"] description:[results stringForColumn:@"description"] protocolId:[results stringForColumn:@"protocolId"]];
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
        textBlockResults= [db executeQuery:@"SELECT * FROM textBlock WHERE stepId = (:stepId)", stepId];
        while([textBlockResults next])
        {
            TextBlock *t = [[TextBlock alloc] initWithTitle:[textBlockResults stringForColumn:@"title"] content:[textBlockResults stringForColumn:@"content"] printable:[textBlockResults boolForColumn:@"printable"] objectId:[textBlockResults stringForColumn:@"objectId"] stepId:[textBlockResults stringForColumn:@"stepId"] orderNumber:[textBlockResults intForColumn:@"orderNumber"]];
            [components addObject:t];
        }
        FMResultSet *calculatorResults = [db executeQuery:@"SELECT * FROM calculator  WHERE stepId = (:stepId)", stepId];
        while([textBlockResults next])
        {
            Calculator *calculator = [[Calculator alloc]initWithObjectId:[calculatorResults stringForColumn:@"objectId"] stepId:[calculatorResults stringForColumn:@"stepId"] orderNumber:[calculatorResults intForColumn:@"orderNumber"]];
            [components addObject:calculator];
        }
        
        FMResultSet *linkResults = [db executeQuery:@"SELECT * FROM link WHERE stepId = (:stepId)", stepId];
        while([linkResults next])
        {
            Link *link = [[Link alloc] initWithLabel:[linkResults stringForColumn:@"label"] url:[linkResults stringForColumn:@"url"] objectId:[linkResults stringForColumn:@"objectId"] stepId:[linkResults stringForColumn:@"stepId"] orderNumber:[linkResults intForColumn:@"orderNumber"]];
            [components addObject:link];
        }
        if ([db hadError]) {
            NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        [db close];
    }
    return components;
}

-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)objectId withObject:(NSString*)object{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    bool success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        NSLog(@"UPDATING PROTOCOL : %@", objectId);
        MedProtocol *medProtocol = (MedProtocol*) object;
        NSLog(@"NEW NAME: %@", medProtocol.name);
        success = [db executeUpdate:@"UPDATE protocol SET pName = (:pName) WHERE objectId = (:objectId) ", medProtocol.name, objectId];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *step = (ProtocolStep *)object;
        success = [db executeUpdate:@"UPDATE step SET orderNumber = (:orderNumber), description = (:description) WHERE objectId = (:objectId)", [NSNumber numberWithInt:step.orderNumber], step.description, objectId];
    }
    else if([object isKindOfClass:[Form class]])
    {
            //Form is not updatable, it serves as a joining table between a step and form components
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *textBlock = (TextBlock *) object;
        success = [db executeUpdate:@"UPDATE textBlock SET orderNumber = (:orderNumber), printable = (:printable), title = (:title) WHERE objectId = (:objectId)", [NSNumber numberWithInt:textBlock.orderNumber] ,[NSNumber numberWithBool:textBlock.printable], textBlock.title, objectId];
    }
    else if([object isKindOfClass:[Link class]])
    {
        Link *link = (Link *) object;
        success = [db executeUpdate:@"UPDATE link SET orderNumber = (:orderNumber), url = (:url), label = (:label) WHERE objectId = (:objectId)",[NSNumber numberWithInt:link.orderNumber], link.url, link.label, objectId];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        //Calculator still needs to be worked out (is it similar to a form?)
       // Calculator *calculator = (Calculator*)object;
       // success = [db executeUpdate:@"UPDATE calculator SET id = ?, stepId = ? WHERE id = ?", calculator.objectId, calculator.stepId, objectId];
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        FormNumber *formNumber = (FormNumber*)object;
        success = [db executeUpdate:@"UPDATE formNumber SET orderNumber = (:orderNumber), defaultValue = (:defaultValue), minValue = (:minValue), maxValue = (:maxValue), label = (:label) WHERE objectId = (:objectId)", [NSNumber numberWithInt:formNumber.orderNumber], [NSNumber numberWithInt:formNumber.defaultValue],[NSNumber numberWithInt:formNumber.minValue], [NSNumber numberWithInt:formNumber.maxValue], formNumber.label, objectId];
    }
    else if([object isKindOfClass:[FormSelection class]])
    {
        FormSelection *formSelection = (FormSelection*)object;
        success = [db executeUpdate:@"UPDATE formSelection SET orderNumber = (:orderNumber), choiceA = (:choiceA), choiceB = (:choiceB), label = (:label) WHERE objectId = (:objectId)", [NSNumber numberWithInt:formSelection.orderNumber], formSelection.choiceA,formSelection.choiceB,formSelection.label, objectId];
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
        success =  [db executeUpdate:@"INSERT INTO protocol (objectId, pName) VALUES (:objectId,:pName)", medProtocol.objectId, medProtocol.name];
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *step = (ProtocolStep*)object;
        success =  [db executeUpdate:@"INSERT INTO step (objectId, orderNumber, protocolId, description) VALUES (:objectId,:orderNumber,:protocolId,:description)",step.objectId, [NSNumber numberWithInt:step.orderNumber], step.protocolId, step.description];
    }
    
    else if([object isKindOfClass:[Form class]])
    {
        Form *form = (Form *) object;
        success = [db executeUpdate:@"INSERT INTO form (objectId, stepId, orderNumber) VALUES (:objectId,:stepId,:orderNumber)", form.objectId, form.stepId, [NSNumber numberWithInt:form.orderNumber]];
    }
    
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock *textBlock = (TextBlock *) object;
        success = [db executeUpdate:@"INSERT INTO textBlock (objectId,printable,title,stepId,content, orderNumber) VALUES (:objectId,:printable,:title,:stepId,:content, :orderNumber)", textBlock.objectId, [NSNumber numberWithBool:textBlock.printable], textBlock.title, textBlock.stepId,textBlock.content, [NSNumber numberWithInt:textBlock.orderNumber]];
    }
    
    else if([object isKindOfClass:[Link class]])
    {
        Link *link = (Link *)object;
        success = [db executeUpdate:@"INSERT INTO link (objectId,url,label,stepId, orderNumber) VALUES (:objectId,:url,:label,:stepId,:orderNumber)", link.objectId, link.url, link.label, link.stepId, [NSNumber numberWithInt:link.orderNumber]];
    }
    
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator *calculator = (Calculator *)object;
        success = [db executeUpdate:@"INSERT INTO calculator (objectId,stepId,orderNumber) VALUES (:objectId,:stepId,:orderNumber)",calculator.objectId, calculator.stepId, [NSNumber numberWithInt:calculator.orderNumber]];
    }
    else if([object isKindOfClass:[FormSelection class]])
    {
        FormSelection *formSelection = (FormSelection *)object;
        success = [db executeUpdate:@"INSERT INTO formSelection (objectId,choiceA,choiceB,label,formId,orderNumber) VALUES (:objectId,:choiceA,:choiceB,:label,:formId,:orderNumber)",formSelection.objectId, formSelection.choiceA, formSelection.choiceB, formSelection.label, formSelection.formId, [NSNumber numberWithInt:formSelection.orderNumber]];
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        FormNumber *formNumber = (FormNumber *)object;
        success = [db executeUpdate:@"INSERT INTO formNumber (objectId,defaultValue,minValue,maxValue,label,formId,orderNumber) VALUES (:objectId,:defaultValue,:minValue,:maxValue,:label,:formId,:orderNumber)",formNumber.objectId, [NSNumber numberWithInt:formNumber.defaultValue],[NSNumber numberWithInt:formNumber.minValue],[NSNumber numberWithInt:formNumber.maxValue],formNumber.label,formNumber.formId, [NSNumber numberWithInt:formNumber.orderNumber]];
    }
    return success;
}

-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)objectId{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    bool protocol = NO, step = NO, textBlock = NO, link = NO, form = NO, calculator = NO, formNumber = NO, formSelection = NO;
    
    switch (dataType) {
        case DataTypeProtocol:
            [self deleteObjectWithDataType:DataTypeStep withId:objectId]; //recursive call to delete steps associated with this particular protocol
            protocol = [db executeUpdate:@"DELETE FROM protocol WHERE objectId = (:objectId)", objectId];
        case DataTypeStep:
            [self deleteObjectWithDataType:DataTypeComponent withId:objectId];//recursive call to delete components associated with this particular step
            step = [db executeUpdate:@"DELETE FROM step WHERE objectId = (:objectId)", objectId];
        case DataTypeComponent:
            [self deleteObjectWithDataType:DataTypeFormComponent withId:objectId];//recursive call to delete formComponents associated with this particular form
            textBlock = [db executeUpdate:@"DELETE FROM textBlock WHERE stepId = (:stepId)", objectId];
            form = [db executeUpdate:@"DELETE FROM form WHERE stepId = (:stepId)", objectId];
            link = [db executeUpdate:@"DELETE FROM link WHERE stepId = (:stepId)", objectId];
            calculator = [db executeUpdate:@"DELETE FROM calculator WHERE stepId = (:stepId)", objectId];
        case DataTypeFormComponent:
            formNumber = [db executeUpdate:@"DELETE FROM formNumber WHERE formId = (:formId)", objectId];
            formSelection = [db executeUpdate:@"DELETE FROM formSelection WHERE formId = (:formId)", objectId];
        default:
            break;
    }
    return protocol || step || textBlock || link || form || calculator || formNumber || formSelection;
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
    else if([object isKindOfClass:[TextBlock class]])
    {
        className = @"TextBlock";
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
