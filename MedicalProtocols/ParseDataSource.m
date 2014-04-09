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
        sharedObject.delegate = delegate;
        sharedObject.runningQueries = 0;
    }
    return sharedObject;
}
-(void)setRunningQueries:(int)runningQueries{
    _runningQueries = runningQueries;
    if(runningQueries == 0){
        [self.delegate ParseDataFinishedDownloading];
    }
}
#pragma mark Parse Methods
-(NSMutableArray*)getAllFromParseClassNamed:(NSString*)className{
    PFQuery *query = [PFQuery queryWithClassName:className];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d sprotocols.", objects.count);
            // Do something with the found objects
            NSMutableArray* parseObjects = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                if([className isEqualToString:@"Protocol"]){
                    MedProtocol *protocol = [[MedProtocol alloc] initWithName:object[@"name"] objectId:object[@"objectID"]];
                    [parseObjects addObject:protocol];
                }
                else if([className isEqualToString:@"Step"]){
                    ProtocolStep *step = [[ProtocolStep alloc] initWithId:object[@"objectId"] stepNumber:[object[@"stepNumber"]intValue] description:object[@"description"] protocolId:object[@"protocol"]];
                    [parseObjects addObject:step];
                }
                else if([className isEqualToString:@"Form"]){
                    Form *form = [[Form alloc] initWithObjectId:object[@"objectId"] stepId:object[@"stepId"]];
                    [parseObjects addObject:form];
                }
                else if([className isEqualToString:@"Link"]){
                    Link *link = [[Link alloc]initWithLabel:object[@"label"] url:object[@"url"] objectId:object[@"objectId"] stepId:object[@"stepId"]];
                    [parseObjects addObject:link];
                }
                else if([className isEqualToString:@"Calculator"]){
                    Calculator *calculator = [[Calculator alloc] initWithObjectId:object[@"objectId"] stepId:object[@"stepId"]];
                    [parseObjects addObject:calculator];
                }
                else if([className isEqualToString:@"TextBlock"]){
                    TextBlock *textBlock = [[TextBlock alloc] initWithTitle:object[@"title"] content:object[@"content"] printable:[object[@"printable"]boolValue] objectId:object[@"objectId"] stepId:object[@"stepId"]];
                    [parseObjects addObject:textBlock];
                }
                else if([className isEqualToString:@"FormNumber"]){
                    FormNumber *formNumber = [[FormNumber alloc]initWithLabel:object[@"label"] defaultValue:[object[@"defaultValue"]intValue] minValue:[object[@"minValue"]intValue] maxValue:[object[@"maxValue"]intValue] objectId:object[@"objectId"] formId:object[@"formId"]];
                    [parseObjects addObject:formNumber];
                }else{
                    FormSelection *formSelection = [[FormSelection alloc] initWithLabel:object[@"label"] choiceA:object[@"choiceA"] choiceB:object[@"choiceB"] objectId:object[@"objectId"] formId:object[@"formId"]];
                    [parseObjects addObject:formSelection];
                }
            }
            [self.delegate downloadedParseObjects:parseObjects withDataType:DataTypeProtocol];
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
                if([form.stepId isEqualToString:parentId])
                    [componentsWithParentId addObject:form];
                    }
        }
        else if([className isEqualToString:@"Link"]){
            for(Link *link in stepComponents){
                if([link.stepId isEqualToString:parentId])
                    [componentsWithParentId addObject:link];
            }
        }
        else if([className isEqualToString:@"Calculator"]){
            for(Calculator* calculator in stepComponents){
                if([calculator.stepId isEqualToString:parentId])
                    [componentsWithParentId addObject:calculator];
            }
        }else{
            for(TextBlock* textBlock in stepComponents){
                if([textBlock.stepId isEqualToString:parentId])
                    [componentsWithParentId addObject:textBlock];
            }
        }
    }
    return componentsWithParentId;

}

-(NSMutableArray*)getFormComponents{
    NSArray* parseClassNames = @[@"FromNumber",@"FormSelection"];
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
                if([formNumber.formId isEqualToString:parentId])
                    [formComponentsWithParentId addObject:formNumber];
            }
        }else{
            for(FormSelection* formSelection in formComponents){
                if([formSelection.objectId isEqualToString:parentId])
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
                //TODO fix this so the parse query is smaller and takes into accoun parent id
                NSMutableArray *steps = [[NSMutableArray alloc]init];
                steps = [self getAllFromParseClassNamed:@"Step"];
                for(ProtocolStep* step in steps){
                    if([step.protocolId isEqualToString:parentId])
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
-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    __block id obj;
    PFQuery *query;
    NSArray *tableNames = [self tableNamesForDataType:dataType];
    for(NSString* tableName in tableNames){
        query = [PFQuery queryWithClassName:[tableNames objectAtIndex:[tableNames indexOfObject:tableName]]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            {
                if(!error){
                    [self.delegate downloadedParseObjects:[objects objectAtIndex:[tableNames indexOfObject:tableName]] withDataType:dataType];
                }
            }
        }];
    }
    return obj;
}

-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    PFQuery* query;
    __block BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *protocol = (MedProtocol*)object;
        query = [PFQuery queryWithClassName:@"Protocol"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseProtocolObject, NSError *error) {
            {
                if(!error){
                    parseProtocolObject[@"objectId"] = protocol.objectId;
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
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseStepObject, NSError *error) {
                if(!error){
                    parseStepObject[@"objectId"] = step.objectId;
                    parseStepObject[@"stepNumber"] = [NSNumber numberWithInt:step.stepNumber];
                    PFObject* protocol = parseStepObject[@"protocol"];
                    protocol.objectId = step.protocolId;
                    [parseStepObject saveInBackground];
                    success = YES;
                }
            }];
        }
    else if([object isKindOfClass:[Form class]])
    {
        Form* form = (Form*)object;
        query = [PFQuery queryWithClassName:@"Form"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseFormObject, NSError *error) {
            {
                if(!error){
                    parseFormObject[@"objectId"] = form.objectId;
                    parseFormObject[@"step"] = form.stepId;
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
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseTextBlockObject, NSError *error) {
            {
                if(!error){
                    parseTextBlockObject[@"objectId"] = textBlock.objectId;
                    parseTextBlockObject[@"printable"] = [NSNumber numberWithBool:[textBlock printable]];
                    parseTextBlockObject[@"title"] = textBlock.title;
                    parseTextBlockObject[@"step"] = textBlock.stepId;
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
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseLinkObject, NSError *error) {
            {
                if(!error){
                    parseLinkObject[@"objectId"] = link.objectId;
                    parseLinkObject[@"url"] = link.url;
                    parseLinkObject[@"printable"] = [NSNumber numberWithBool:[link printable]];
                    parseLinkObject[@"label"] = link.label;
                    parseLinkObject[@"step"] = link.stepId;
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
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseCalculatorObject, NSError *error) {
            {
                if(!error){
                    parseCalculatorObject[@"objectId"] = calculator.objectId;
                    parseCalculatorObject[@"updatedAt"] = calculator.updatedAt;
                    parseCalculatorObject[@"step"] = calculator.stepId;
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
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseFormSelectionObject, NSError *error) {
            {
                if(!error){
                    parseFormSelectionObject[@"objectId"] = formSelection.objectId;
                    parseFormSelectionObject[@"updatedAt"] = formSelection.updatedAt;
                    parseFormSelectionObject[@"form"] = formSelection.formId;
                    parseFormSelectionObject[@"label"] = formSelection.label;
                    parseFormSelectionObject[@"choiceA"] = formSelection.choiceA;
                    parseFormSelectionObject[@"choiceB"] = formSelection.choiceB;
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
        [query getObjectInBackgroundWithId:idString block:^(PFObject *parseFormNumberObject, NSError *error) {
            {
                if(!error){
                    parseFormNumberObject[@"objectId"] = formNumber.objectId;
                    parseFormNumberObject[@"updatedAt"] = formNumber.updatedAt;
                    parseFormNumberObject[@"form"] = formNumber.formId;
                    parseFormNumberObject[@"defaultValue"] = [NSNumber numberWithInt:formNumber.defaultValue];
                    parseFormNumberObject[@"minValue"] = [NSNumber numberWithInt:formNumber.minValue];
                    parseFormNumberObject[@"maxValue"] = [NSNumber numberWithInt:formNumber.maxValue];
                    parseFormNumberObject[@"label"] = formNumber.label;
                    [parseFormNumberObject saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    
    return success;
}
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
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
        parseStepObject[@"stepNumber"] = [NSNumber numberWithInt:step.stepNumber];
        parseStepObject[@"protocol"] = step.protocolId; //Parse refers to protocolId as protocol this is the foreign key in Step
        parseStepObject[@"description"] = step.description;
        [parseStepObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[TextBlock class]]){
        TextBlock* textBlock = (TextBlock*)object;
        PFObject *parseTextBlockObject = [PFObject objectWithClassName:@"TextBlock"];
        parseTextBlockObject[@"printable"] = [NSNumber numberWithBool:textBlock.printable];
        parseTextBlockObject[@"title"] = textBlock.title;
        parseTextBlockObject[@"step"] = textBlock.stepId;  //Parse refers to stepId as step this is the foreign key in TextBlock
        [parseTextBlockObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Calculator class]]){
        Calculator* calculator = (Calculator*)object;
        PFObject *parseCalculatorObject = [PFObject objectWithClassName:@"Calculator"];
        parseCalculatorObject[@"step"] = calculator.stepId; //Parse refers to stepId as step this is the foreign key in Calculator
        [parseCalculatorObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Link class]]){
        Link* link = (Link*)object;
        PFObject *parseLinkObject = [PFObject objectWithClassName:@"Link"];
        parseLinkObject[@"url"] = link.url;
        parseLinkObject[@"label"] = link.label;
        parseLinkObject[@"printable"] = [NSNumber numberWithBool:link.printable];
        parseLinkObject[@"step"] = link.stepId;  //Parse refers to stepId as step this is the foreign key in Link
        [parseLinkObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Form class]]){
        Form* form = (Form*)object;
        PFObject *parseFormObject = [PFObject objectWithClassName:@"Form"];
        parseFormObject[@"step"] = form.stepId;
        [parseFormObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[FormSelection class]]){
        FormSelection* formSelection = (FormSelection*)object;
        PFObject *parseFormSelectionObject = [PFObject objectWithClassName:@"FormSelection"];
        parseFormSelectionObject[@"label"] = formSelection.label;
        parseFormSelectionObject[@"form"] = formSelection.formId;  //Parse refers to formId as form this is the foreign key in FormSelection
        parseFormSelectionObject[@"choiceA"] = formSelection.choiceA;
        parseFormSelectionObject[@"choiceB"] = formSelection.choiceB;
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
        parseFormNumberObject[@"form"] = formNumber.formId; //Parse refers to formId as form this is the foreign key in FormNumber
        [parseFormNumberObject saveInBackground];
        success = YES;
    }
    
    return success;
}

@end
