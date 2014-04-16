//
//  ParseDataSource.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ParseDataSource.h"
#import <Parse/Parse.h>
#import "MedProtocol.h"
#import "ProtocolStep.h"
#import "TextBlock.h"
#import "Link.h"
#import "Calculator.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"

@interface ParseDataSource()
-(NSMutableArray*)getAllFromParseClassNamed:(NSString*)className;
@property (nonatomic,assign) int runningQueries;
@property(nonatomic,assign,readwrite) bool dataSourceReady;
@end

@implementation ParseDataSource
+(ParseDataSource *) sharedInstance{
    return [ParseDataSource sharedInstanceWithDelegate:nil];
}
+(ParseDataSource *) sharedInstanceWithDelegate:(id<ParseDataDownloadedDelegate,ParseDataDownloadedDelegate>)delegate
{
    static ParseDataSource* sharedObject = nil;
    if(sharedObject == nil){
        sharedObject = [[ParseDataSource alloc] init];
        sharedObject.runningQueries = 0;
    }
    if(delegate != nil){
        sharedObject.delegate = delegate;
    }
    return sharedObject;
}
-(void)setRunningQueries:(int)runningQueries{
    _runningQueries = runningQueries;
    if(runningQueries == 0){
        self.dataSourceReady = YES;
        [self.delegate ParseDataFinishedDownloading];
    } else {
        self.dataSourceReady = NO;
    }
}
-(void)downloadAllTablesFromParse{
    self.runningQueries = 4;
    [self getAllObjectsWithDataType:DataTypeProtocol];
    [self getAllObjectsWithDataType:DataTypeStep];
    [self getAllObjectsWithDataType:DataTypeComponent];
    [self getAllObjectsWithDataType:DataTypeFormComponent];
}
#pragma mark Parse Methods
-(NSMutableArray*)getAllFromParseClassNamed:(NSString*)className{
    PFQuery *query = [PFQuery queryWithClassName:className];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d objects from Class %@.", objects.count,className);
            // Do something with the found objects
            NSMutableArray* parseObjects = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                if([className isEqualToString:@"Protocol"]){
                    MedProtocol *protocol = [[MedProtocol alloc] initWithName:object[@"name"] objectId:object[@"UUID"]];
                    [parseObjects addObject:protocol];
                }
                else if([className isEqualToString:@"Step"]){
                    ProtocolStep *step = [[ProtocolStep alloc] initWithId:object[@"UUID"] orderNumber:[object[@"orderNumber"]intValue] description:object[@"description"] protocolId:object[@"parentUUID"]];
                    [parseObjects addObject:step];
                }
                else if([className isEqualToString:@"Form"]){
                    Form *form = [[Form alloc] initWithObjectId:object[@"UUID"] stepId:object[@"parentUUID"] orderNumber:[object[@"orderNumber"]intValue]];
                    [parseObjects addObject:form];
                }
                else if([className isEqualToString:@"Link"]){
                    Link *link = [[Link alloc]initWithLabel:object[@"label"] url:object[@"url"] objectId:object[@"UUID"] stepId:object[@"parentUUID"]orderNumber:[object[@"orderNumber"]intValue]];
                    [parseObjects addObject:link];
                }
                else if([className isEqualToString:@"Calculator"]){
                    Calculator *calculator = [[Calculator alloc] initWithObjectId:object[@"UUID"] stepId:object[@"parentUUID"] orderNumber:[object[@"orderNumber"]intValue]];
                    [parseObjects addObject:calculator];
                }
                else if([className isEqualToString:@"TextBlock"]){
                    TextBlock *textBlock = [[TextBlock alloc] initWithTitle:object[@"title"] content:object[@"content"] printable:[object[@"printable"]boolValue] objectId:object[@"UUID"] stepId:object[@"parentUUID"] orderNumber:[object[@"orderNumber"]intValue]];
                    [parseObjects addObject:textBlock];
                }
                else if([className isEqualToString:@"FormNumber"]){
                    FormNumber *formNumber = [[FormNumber alloc]initWithLabel:object[@"label"] defaultValue:[object[@"defaultValue"]intValue] minValue:[object[@"minValue"]intValue] maxValue:[object[@"maxValue"]intValue] objectId:object[@"UUID"] orderNumber:[object[@"orderNumber"]intValue] formId:object[@"parentUUID"]];
                    [parseObjects addObject:formNumber];
                }else{
                    FormSelection *formSelection = [[FormSelection alloc] initWithLabel:object[@"label"] choiceA:object[@"choiceA"] choiceB:object[@"choiceB"] objectId:object[@"UUID"] orderNumber:[object[@"orderNumber"]intValue] formId:object[@"parentUUID"]];
                    [parseObjects addObject:formSelection];
                }
            }
            [self.delegate downloadedParseObjects:parseObjects withDataType:DataTypeProtocol];
            self.runningQueries--;
        }
    }];
    return nil;
}

-(NSMutableArray*)getStepComponents{
    NSArray *parseClassNames = @[@"Form", @"Link", @"Calculator", @"TextBlock"];
    NSMutableArray* stepComponents = [[NSMutableArray alloc]  init];
    for(NSString* className in parseClassNames){
        [stepComponents addObjectsFromArray:[self getAllFromParseClassNamed:className]];
    }
    return stepComponents;
    
}

-(NSMutableArray*)getStepComponentsWithParentId:(NSString*)parentId{
    NSArray *parseClassNames = @[@"Form", @"Link", @"Calculator", @"TextBlock"];
    NSMutableArray* stepComponents = [[NSMutableArray alloc]init];
    NSMutableArray* componentsWithParentId = [[NSMutableArray alloc]init];
    for(NSString* className in parseClassNames){
        [stepComponents addObjectsFromArray:[self getAllFromParseClassNamed:className]];
        if([className isEqualToString: @"Form"]){
            for(Form* form in stepComponents){
                if([form.stepId isEqual:parentId])
                    [componentsWithParentId addObject:form];
            }
        }
        else if([className isEqualToString:@"Link"]){
            for(Link *link in stepComponents){
                if([link.stepId isEqual:parentId])
                    [componentsWithParentId addObject:link];
            }
        }
        else if([className isEqualToString:@"Calculator"]){
            for(Calculator* calculator in stepComponents){
                if([calculator.stepId isEqual:parentId])
                    [componentsWithParentId addObject:calculator];
            }
        }else{
            for(TextBlock* textBlock in stepComponents){
                if([textBlock.stepId isEqual:parentId])
                    [componentsWithParentId addObject:textBlock];
            }
        }
    }
    return componentsWithParentId;

}

-(NSMutableArray*)getFormComponents{
    NSArray* parseClassNames = @[@"FormNumber",@"FormSelection"];
    NSMutableArray* formComponents = [[NSMutableArray alloc]  init];
    for(NSString* className in parseClassNames){
        [formComponents addObjectsFromArray:[self getAllFromParseClassNamed:className]];
    }
    return formComponents;
}

-(NSMutableArray*)getFormComponentsWithParentId:(NSString*)parentId{
    NSArray* parseClassNames = @[@"FromNumber",@"FormSelection"];
    NSMutableArray* formComponents = [[NSMutableArray alloc]  init];
    NSMutableArray* formComponentsWithParentId = [[NSMutableArray alloc]init];
    for(NSString* className in parseClassNames){
        [formComponents addObjectsFromArray:[self getAllFromParseClassNamed:className]];
        if([className isEqualToString: @"FormNumber"]){
            for(FormNumber* formNumber in formComponents){
                if([formNumber.formId isEqual:parentId])
                    [formComponentsWithParentId addObject:formNumber];
            }
        }else{
            for(FormSelection* formSelection in formComponents){
                if([formSelection.objectId isEqual:parentId])
                    [formComponentsWithParentId addObject:formSelection];
            }
        }

    }
    return formComponentsWithParentId;
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
    else if([object isKindOfClass:[FormSelection class]])
    {
        className = @"FormSelection";
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        className = @"FormNumber";
    }    else if([object isKindOfClass:[FormSelection class]])
    {
        className = @"FormSelection";
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        className = @"FormNumber";
    }
    return className;
}

#pragma mark MedRefDataSource

-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    NSMutableArray* dataTypes = nil;
    switch (dataType) {
        case DataTypeProtocol:
            dataTypes = [self getAllFromParseClassNamed:@"Protocol"];
            break;
            
        case DataTypeStep:
            dataTypes = [self getAllFromParseClassNamed:@"Step"];
            break;
            
        case DataTypeComponent:
            dataTypes = [self getStepComponents];
            break;
            
        case DataTypeFormComponent:
            dataTypes = [self getFormComponents];
            break;
            
        default:
            break;
    }
    return dataTypes;
}

-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(NSString*)parentId{
    NSMutableArray *objectsWithParentId = nil;
    switch (dataType) {
        case DataTypeProtocol:
            objectsWithParentId = [self getAllFromParseClassNamed:@"Protocol"];
            break;
        case DataTypeStep:
            if(true){
                NSMutableArray *steps = [[NSMutableArray alloc]init];
                steps = [self getAllFromParseClassNamed:@"Step"];
                for(ProtocolStep* step in steps){
                    if([step.protocolId isEqual:parentId])
                        [objectsWithParentId addObject:step];
                }
            }
            break;
        case DataTypeComponent:
            objectsWithParentId = [self getStepComponentsWithParentId:parentId];
            break;
        case DataTypeFormComponent:
            objectsWithParentId = [self getFormComponentsWithParentId:parentId];
            break;
        default:
            break;
    }
    return objectsWithParentId;
}

-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)objectId{
    __block id obj;
    PFQuery *query;
    NSArray *tableNames = [self tableNamesForDataType:dataType];
    for(NSString* tableName in tableNames){
        query = [PFQuery queryWithClassName:[tableNames objectAtIndex:[tableNames indexOfObject:tableName]]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            {
                if(!error){
                    [self.delegate downloadedParseObjects:[objects objectAtIndex:[tableNames indexOfObject:tableName]] withDataType:dataType];
                     self.runningQueries--;
                }
            }
        }];
    }
    return obj;
}

-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)objectId withObject:(id)object{
    PFQuery* query;
    __block BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *protocol = (MedProtocol*)object;
        query = [PFQuery queryWithClassName:@"Protocol"];
        [query whereKey:@"databaseId" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseProtocolObject, NSError *error) {
            {
                if(!error){
                    parseProtocolObject[@"UUID"] = protocol.objectId;
                    parseProtocolObject[@"name"] = protocol.name;
                    [parseProtocolObject saveInBackground];
                    success = YES;
                }
            }
        }];
        
    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        ProtocolStep *step = (ProtocolStep*)object;
        query = [PFQuery queryWithClassName:@"Step"];
        [query includeKey:@"protocol"];
        [query whereKey:@"UUID" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseStepObject, NSError *error) {
                if(!error){
                    parseStepObject[@"UUID"] = step.objectId;
                    parseStepObject[@"orderNumber"] = [NSNumber numberWithInt:step.orderNumber];
                    parseStepObject[@"parentUUID"] = step.protocolId;
                    [parseStepObject saveInBackground];
                    success = YES;
                }
            }];
        }
    else if([object isKindOfClass:[Form class]])
    {
        Form* form = (Form*)object;
        query = [PFQuery queryWithClassName:@"Form"];
        [query whereKey:@"databaseId" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseFormObject, NSError *error) {
            {
                if(!error){
                    parseFormObject[@"UUID"] = form.objectId;
                    parseFormObject[@"parentUUID"] = form.stepId;
                    parseFormObject[@"orderNumber"] = [NSNumber numberWithInt:form.orderNumber];
                    [parseFormObject saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        TextBlock* textBlock = (TextBlock*)object;
        query = [PFQuery queryWithClassName:@"TextBlock"];
        [query whereKey:@"UUID" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseTextBlockObject, NSError *error) {
            {
                if(!error){
                    parseTextBlockObject[@"UUID"] = textBlock.objectId;
                    parseTextBlockObject[@"printable"] = [NSNumber numberWithBool:[textBlock printable]];
                    parseTextBlockObject[@"title"] = textBlock.title;
                    parseTextBlockObject[@"parentUUID"] = textBlock.stepId;
                    parseTextBlockObject[@"orderNumber"] = [NSNumber numberWithInt:textBlock.orderNumber];
                    [parseTextBlockObject saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[Link class]])
    {
        Link* link = (Link *)object;
        query = [PFQuery queryWithClassName:@"Link"];
        [query whereKey:@"UUID" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseLinkObject, NSError *error) {
            {
                if(!error){
                    parseLinkObject[@"UUID"] = link.objectId;
                    parseLinkObject[@"url"] = link.url;
                    parseLinkObject[@"label"] = link.label;
                    parseLinkObject[@"parentUUID"] = link.stepId;
                    parseLinkObject[@"orderNumber"] = [NSNumber numberWithInt:link.orderNumber];
                    [parseLinkObject saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        Calculator* calculator = (Calculator*)object;
        query = [PFQuery queryWithClassName:@"Calculator"];
        [query whereKey:@"UUID" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseCalculatorObject, NSError *error) {
            {
                if(!error){
                    parseCalculatorObject[@"UUID"] = calculator.objectId;
                    parseCalculatorObject[@"parentUUID"] = calculator.stepId;
                    parseCalculatorObject[@"orderNumber"] = [NSNumber numberWithInt:calculator.orderNumber];
                    [parseCalculatorObject saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[FormSelection class]])
    {
        FormSelection* formSelection = (FormSelection*)object;
        query = [PFQuery queryWithClassName:@"FormSelection"];
        [query whereKey:@"UUID" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseFormSelectionObject, NSError *error) {
            {
                if(!error){
                    parseFormSelectionObject[@"UUID"] = formSelection.objectId;
                    parseFormSelectionObject[@"parentUUID"] = formSelection.objectId;
                    parseFormSelectionObject[@"label"] = formSelection.label;
                    parseFormSelectionObject[@"choiceA"] = formSelection.choiceA;
                    parseFormSelectionObject[@"choiceB"] = formSelection.choiceB;
                    parseFormSelectionObject[@"orderNumber"] = [NSNumber numberWithInt:formSelection.orderNumber];
                    [parseFormSelectionObject saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        FormNumber* formNumber = (FormNumber*)object;
        query = [PFQuery queryWithClassName:@"FormNumber"];
        [query whereKey:@"UUID" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseFormNumberObject, NSError *error) {
            {
                if(!error){
                    parseFormNumberObject[@"UUID"] = formNumber.objectId;
                    parseFormNumberObject[@"parentUUID"] = formNumber.formId;
                    parseFormNumberObject[@"defaultValue"] = [NSNumber numberWithInt:formNumber.defaultValue];
                    parseFormNumberObject[@"minValue"] = [NSNumber numberWithInt:formNumber.minValue];
                    parseFormNumberObject[@"maxValue"] = [NSNumber numberWithInt:formNumber.maxValue];
                    parseFormNumberObject[@"label"] = formNumber.label;
                    parseFormNumberObject[@"orderNumber"] = [NSNumber numberWithInt:formNumber.orderNumber];
                    [parseFormNumberObject saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    
    return success;
}
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)objectId isChild:(bool)isChild{
    __block id obj;
    __block BOOL success;
    success = NO;
    PFQuery *query;
    NSArray *tableNames = [self tableNamesForDataType:dataType];
    for(NSString* tableName in tableNames){
        query = [PFQuery queryWithClassName:[tableNames objectAtIndex:[tableNames indexOfObject:tableName]]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            {
                if(!error){
                    [obj deleteInBackground];
                    success = YES;
                }
            }
        }];
    }
    return success;
}
-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]]){
        MedProtocol* protocol = (MedProtocol*)object;
        PFObject *parseProtocolObject = [PFObject objectWithClassName:@"Protocol"];
        parseProtocolObject[@"name"] = protocol.name;
        [parseProtocolObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[ProtocolStep class]]){
        ProtocolStep* step = (ProtocolStep*)object;
        PFObject *parseStepObject = [PFObject objectWithClassName:@"Step"];
        parseStepObject[@"orderNumber"] = [NSNumber numberWithInt:step.orderNumber];
        parseStepObject[@"parentUUID"] = step.protocolId; //Parse refers to protocolId as protocol this is the foreign key in Step
        parseStepObject[@"description"] = step.description;
        [parseStepObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[TextBlock class]]){
        TextBlock* textBlock = (TextBlock*)object;
        PFObject *parseTextBlockObject = [PFObject objectWithClassName:@"TextBlock"];
        parseTextBlockObject[@"printable"] = [NSNumber numberWithBool:textBlock.printable];
        parseTextBlockObject[@"orderNumber"] = [NSNumber numberWithInt:textBlock.orderNumber];
        parseTextBlockObject[@"title"] = textBlock.title;
        parseTextBlockObject[@"parentUUID"] = textBlock.stepId;  //Parse refers to stepId as step this is the foreign key in TextBlock
        [parseTextBlockObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Calculator class]]){
        Calculator* calculator = (Calculator*)object;
        PFObject *parseCalculatorObject = [PFObject objectWithClassName:@"Calculator"];
        parseCalculatorObject[@"orderNumber"] = [NSNumber numberWithInt:calculator.orderNumber];
        parseCalculatorObject[@"parentUUID"] = calculator.stepId;
        [parseCalculatorObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Link class]]){
        Link* link = (Link*)object;
        PFObject *parseLinkObject = [PFObject objectWithClassName:@"Link"];
        parseLinkObject[@"url"] = link.url;
        parseLinkObject[@"label"] = link.label;
        parseLinkObject[@"parentUUID"] = link.stepId;
        parseLinkObject[@"orderNumber"] = [NSNumber numberWithInt:link.orderNumber];
        [parseLinkObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Form class]]){
        Form* form = (Form*)object;
        PFObject *parseFormObject = [PFObject objectWithClassName:@"Form"];
        parseFormObject[@"parentUID"] = form.stepId;
        parseFormObject[@"orderNumber"] = [NSNumber numberWithInt:form.orderNumber];
        [parseFormObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[FormSelection class]]){
        FormSelection* formSelection = (FormSelection*)object;
        PFObject *parseFormSelectionObject = [PFObject objectWithClassName:@"FormSelection"];
        parseFormSelectionObject[@"label"] = formSelection.label;
        parseFormSelectionObject[@"parentUUID"] = formSelection.formId;
        parseFormSelectionObject[@"choiceA"] = formSelection.choiceA;
        parseFormSelectionObject[@"choiceB"] = formSelection.choiceB;
        parseFormSelectionObject[@"orderNumber"] = [NSNumber numberWithInt:formSelection.orderNumber];
        [parseFormSelectionObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[FormNumber class]]){
        FormNumber* formNumber = (FormNumber*)object;
        PFObject *parseFormNumberObject = [PFObject objectWithClassName:@"FormNumber"];
        parseFormNumberObject[@"defaultValue"] = [NSNumber numberWithInt:formNumber.defaultValue];
        parseFormNumberObject[@"minValue"] = [NSNumber numberWithInt:formNumber.minValue];
        parseFormNumberObject[@"maxValue"] = [NSNumber numberWithInt:formNumber.maxValue];
        parseFormNumberObject[@"label"] = formNumber.label;
        parseFormNumberObject[@"parentUUID"] = formNumber.formId;
        parseFormNumberObject[@"orderNumber"] = [NSNumber numberWithInt:formNumber.orderNumber];
        [parseFormNumberObject saveInBackground];
        success = YES;
    }
    
    return success;
}

@end
