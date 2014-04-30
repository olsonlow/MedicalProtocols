//
//  ParseDataSource.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
// ParseDataSource interfaces with parse.com to store and retreive protocol data created by and used by this app.
// All queries run by this file are custom Parse API queries and you should see the Parse.com documentation for
// iOS to understand how they work and syntax.  The supporting framework is the Parse.framework located in the Frameworks file.
// Whenever modifying this file, keep in mind that there is an onboard Sqlite database that will likely require similar modifications.
// Also, keep in mind that any modification to data elements in either database will also require modification to the objects as well.
// The onboard Sqlite database is maintained by the LocalDB files and a third party library FMDatabase.  Please see these files for further
// documentation regarding data operations.

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
                    Form *form = [[Form alloc] initWithObjectId:object[@"UUID"] label:object[@"label"] stepId:object[@"parentUUID"] orderNumber:[object[@"orderNumber"]intValue]];
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
            tableNames =@[@"Protocol"];
            break;
        case DataTypeStep:
            tableNames =@[@"Step"];
            break;
        case DataTypeComponent:
            tableNames =@[@"Form", @"Link", @"Calculator", @"TextBlock"];
            break;
        case DataTypeFormComponent:
            tableNames = @[@"FormNumber", @"FormSelection"];
            break;
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
    PFQuery *query;
    NSArray *tableNames = [self tableNamesForDataType:dataType];
    for(NSString* tableName in tableNames){
        query = [PFQuery queryWithClassName:tableName];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            {
                if(!error ){
                    [self.delegate downloadedParseObjects:objects withDataType:dataType];
                     self.runningQueries--;
                }
            }
        }];
    }
    return nil;
}

-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)objectId withObject:(id)object{
    PFQuery* query;
    __block BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *protocol = (MedProtocol*)object;
        query = [PFQuery queryWithClassName:@"Protocol"];
        [query whereKey:@"UUID" equalTo:objectId];
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
                    parseStepObject[@"description"] = step.description;
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
        [query whereKey:@"UUID" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseFormObject, NSError *error) {
            {
                if(!error){
                    parseFormObject[@"UUID"] = form.objectId;
                    parseFormObject[@"parentUUID"] = form.stepId;
                    parseFormObject[@"orderNumber"] = [NSNumber numberWithInt:form.orderNumber];
                    parseFormObject[@"label"] = form.label;
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
                    parseTextBlockObject[@"content"] = textBlock.content;
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
    __block BOOL success;
    success = NO;
    if(dataType == DataTypeProtocol){
        PFQuery *protocolQuery;
        protocolQuery = [PFQuery queryWithClassName:@"Protocol"];
        [protocolQuery whereKey:@"UUID" equalTo:objectId];
        [protocolQuery getFirstObjectInBackgroundWithBlock:^(PFObject* protocol, NSError *error) {
            {
                if(!error){
                    [self deleteObjectWithDataType:DataTypeStep withId:objectId isChild:YES];
                    [protocol deleteInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if(dataType == DataTypeStep){
        if(isChild){
            PFQuery *stepQuery;
            stepQuery = [PFQuery queryWithClassName:@"Step"];
            [stepQuery whereKey:@"parentUUID" equalTo:objectId];
            [stepQuery findObjectsInBackgroundWithBlock:^(NSArray *steps, NSError *error) {
                if(!error){
                    for(PFObject* step in steps){
                        NSString* stepId = step[@"UUID"];
                        [self deleteObjectWithDataType:DataTypeComponent withId:stepId isChild:YES];
                        [step deleteInBackground];
                        success = YES;
                    }
                }
            }];
        }else{
            PFQuery *stepQuery;
            stepQuery = [PFQuery queryWithClassName:@"Step"];
            [stepQuery whereKey:@"UUID" equalTo:objectId];
            [stepQuery findObjectsInBackgroundWithBlock:^(NSArray *steps, NSError *error) {
                if(!error){
                    for(PFObject* step in steps){
                        NSString* stepId = step[@"UUID"];
                        [self deleteObjectWithDataType:DataTypeComponent withId:stepId isChild:YES];
                        [step deleteInBackground];
                        success = YES;
                    }
                }
            }];
        }
    }
    else if(dataType == DataTypeComponent){
        if(isChild){
            NSArray* tableNames = [self tableNamesForDataType:dataType];
            for(NSString* tableName in tableNames){
                PFQuery *query;
                query = [PFQuery queryWithClassName:tableName];
                [query whereKey:@"parentUUID" equalTo:objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError *error){
                    if(!error){
                        for(PFObject* object in objects){
                            NSString* formId = object[@"UUID"];
                            [self deleteObjectWithDataType:DataTypeFormComponent withId:formId isChild:YES];
                            [object deleteInBackground];
                            success = YES;
                        }
                    }
                }];
            }

        }else{
            PFObject* object = [self getObjectWithDataType:dataType withId: objectId];
            if([object isKindOfClass:[Form class]]){
                PFQuery *formQuery;
                formQuery = [PFQuery queryWithClassName:@"Form"];
                [formQuery whereKey:@"UUID" equalTo:objectId];
                [formQuery findObjectsInBackgroundWithBlock:^(NSArray* forms, NSError *error){
                    if(!error){
                        for(PFObject* form in forms){
                            NSString* formId = form[@"UUID"];
                            [self deleteObjectWithDataType:DataTypeFormComponent withId:formId isChild:YES];
                            [form deleteInBackground];
                            success = YES;
                        }
                    }
                }];
            }
            else if([object isKindOfClass:[Link class]]){
                PFQuery *linkQuery;
                linkQuery = [PFQuery queryWithClassName:@"Link"];
                [linkQuery whereKey:@"UUID" equalTo:objectId];
                [linkQuery findObjectsInBackgroundWithBlock:^(NSArray* links, NSError *error){
                    if(!error){
                        for(PFObject* link in links){
                            [link deleteInBackground];
                            success = YES;
                        }
                    }
                }];
            }
            else if([object isKindOfClass:[Calculator class]]){
                PFQuery *calculatorQuery;
                calculatorQuery = [PFQuery queryWithClassName:@"Calculator"];
                [calculatorQuery whereKey:@"UUID" equalTo:objectId];
                [calculatorQuery findObjectsInBackgroundWithBlock:^(NSArray* calculators, NSError *error){
                    if(!error){
                        for(PFObject* calculator in calculators){
                            [calculator deleteInBackground];
                            success = YES;
                        }
                    }
                }];
            }
            else if([object isKindOfClass:[TextBlock class]]){
                PFQuery *textBlockQuery;
                textBlockQuery = [PFQuery queryWithClassName:@"TextBlock"];
                [textBlockQuery whereKey:@"UUID" equalTo:objectId];
                [textBlockQuery findObjectsInBackgroundWithBlock:^(NSArray* textBlocks, NSError *error){
                    if(!error){
                        for(PFObject* textBlock in textBlocks){
                            [textBlock deleteInBackground];
                            success = YES;
                        }
                    }
                }];
            }
        }
    }
    else if(dataType == DataTypeFormComponent){
        if(isChild){
            PFQuery *formNumberQuery;
            formNumberQuery = [PFQuery queryWithClassName:@"FormNumber"];
            [formNumberQuery whereKey:@"parentUUID" equalTo:objectId];
            [formNumberQuery findObjectsInBackgroundWithBlock:^(NSArray* formNumbers, NSError *error){
                if(!error){
                    for(PFObject* formNumber in formNumbers){
                        [formNumber deleteInBackground];
                        success = YES;
                    }
                }
            }];
            PFQuery *formSelectionQuery;
            formSelectionQuery = [PFQuery queryWithClassName:@"FormSelection"];
            [formSelectionQuery whereKey:@"parentUUID" equalTo:objectId];
            [formSelectionQuery findObjectsInBackgroundWithBlock:^(NSArray* formSelections, NSError *error){
                if(!error){
                    for(PFObject* formSelection in formSelections){
                        [formSelection deleteInBackground];
                        success = YES;
                    }
                }
            }];
        }else{
            PFQuery *formNumberQuery;
            formNumberQuery = [PFQuery queryWithClassName:@"FormNumber"];
            [formNumberQuery whereKey:@"UUID" equalTo:objectId];
            [formNumberQuery findObjectsInBackgroundWithBlock:^(NSArray* formNumbers, NSError *error){
                if(!error){
                    for(PFObject* formNumber in formNumbers){
                        [formNumber deleteInBackground];
                        success = YES;
                    }
                }
            }];
            PFQuery *formSelectionQuery;
            formSelectionQuery = [PFQuery queryWithClassName:@"FormSelection"];
            [formSelectionQuery whereKey:@"UUID" equalTo:objectId];
            [formSelectionQuery findObjectsInBackgroundWithBlock:^(NSArray* formSelections, NSError *error){
                if(!error){
                    for(PFObject* formSelection in formSelections){
                        [formSelection deleteInBackground];
                        success = YES;
                    }
                }
            }];
        }
    }
    return success;
}


-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]]){
        MedProtocol* protocol = (MedProtocol*)object;
        PFObject *parseProtocolObject = [PFObject objectWithClassName:@"Protocol"];
        parseProtocolObject[@"name"] = protocol.name;
        parseProtocolObject[@"UUID"] = protocol.objectId;
        [parseProtocolObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[ProtocolStep class]]){
        ProtocolStep* step = (ProtocolStep*)object;
        PFObject *parseStepObject = [PFObject objectWithClassName:@"Step"];
        parseStepObject[@"UUID"] = step.objectId;
        parseStepObject[@"orderNumber"] = [NSNumber numberWithInt:step.orderNumber];
        parseStepObject[@"parentUUID"] = step.protocolId; //Parse refers to protocolId as protocol this is the foreign key in Step
        parseStepObject[@"description"] = step.description;
        [parseStepObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[TextBlock class]]){
        TextBlock* textBlock = (TextBlock*)object;
        PFObject *parseTextBlockObject = [PFObject objectWithClassName:@"TextBlock"];
        parseTextBlockObject[@"UUID"] = textBlock.objectId;
        parseTextBlockObject[@"printable"] = [NSNumber numberWithBool:textBlock.printable];
        parseTextBlockObject[@"orderNumber"] = [NSNumber numberWithInt:textBlock.orderNumber];
        parseTextBlockObject[@"title"] = textBlock.title;
        parseTextBlockObject[@"content"] = textBlock.content;
        parseTextBlockObject[@"parentUUID"] = textBlock.stepId;  //Parse refers to stepId as step this is the foreign key in TextBlock
        [parseTextBlockObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Calculator class]]){
        Calculator* calculator = (Calculator*)object;
        PFObject *parseCalculatorObject = [PFObject objectWithClassName:@"Calculator"];
        parseCalculatorObject[@"UUID"] = calculator.objectId;
        parseCalculatorObject[@"orderNumber"] = [NSNumber numberWithInt:calculator.orderNumber];
        parseCalculatorObject[@"parentUUID"] = calculator.stepId;
        [parseCalculatorObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[Link class]]){
        Link* link = (Link*)object;
        PFObject *parseLinkObject = [PFObject objectWithClassName:@"Link"];
        parseLinkObject[@"UUID"] = link.objectId;
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
        parseFormObject[@"UUID"] = form.objectId;
        parseFormObject[@"parentUUID"] = form.stepId;
        parseFormObject[@"orderNumber"] = [NSNumber numberWithInt:form.orderNumber];
        parseFormObject[@"label"] = form.label;
        [parseFormObject saveInBackground];
        success = YES;
    }
    if([object isKindOfClass:[FormSelection class]]){
        FormSelection* formSelection = (FormSelection*)object;
        PFObject *parseFormSelectionObject = [PFObject objectWithClassName:@"FormSelection"];
        parseFormSelectionObject[@"UUID"] = formSelection.objectId;
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
        parseFormNumberObject[@"UUID"] = formNumber.objectId;
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
