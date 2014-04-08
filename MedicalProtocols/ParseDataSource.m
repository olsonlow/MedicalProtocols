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

@end

@implementation ParseDataSource

+(ParseDataSource *)sharedInstance
{
    static ParseDataSource* sharedObject = nil;
    if(sharedObject == nil)
        sharedObject = [[ParseDataSource alloc] init];
    return sharedObject;
}

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

-(NSMutableArray*)getAllFromParseClassNamed:(NSString*)className{
    NSMutableArray* parseObjects = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:className];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d sprotocols.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                if([className isEqualToString:@"Protocol"]){
                    MedProtocol *protocol = [[MedProtocol alloc] initWithName:object[@"name"] objectId:object[@"objectID"]];
//                    protocol.createdAt = object[@"createdAt"];
//                    protocol.updatedAt = object[@"updatedAt"];
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
                    FormNumber *formNumber = [[FormNumber alloc]init];
                    formNumber.label = object[@"label"];
                    formNumber.defaultValue = [object[@"defaultValue"]intValue];
                    formNumber.maxValue= [object[@"maxValue"]intValue];
                    formNumber.minValue = [object[@"minValue"]intValue];
                    formNumber.createdAt = object[@"createdAt"];
                    formNumber.updatedAt = object[@"updatedAt"];
                    formNumber.formNumberId = object[@"objectId"];
                    formNumber.formId = object[@"formId"];
                    [parseObjects addObject:formNumber];
                }else{
                    FormSelection *formSelection = [[FormSelection alloc]init];
                    formSelection.label = object[@"label"];
                    formSelection.choiceA = object[@"choiceA"];
                    formSelection.choiceB = object[@"choiceB"];
                    formSelection.createdAt = object[@"createdAt"];
                    formSelection.updatedAt = object[@"updatedAt"];
                    formSelection.formSelectionId = object[@"objectId"];
                    formSelection.formId = object[@"formId"];
                    [parseObjects addObject:formSelection];
                }
            }
        }
    }];
    return parseObjects;
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
                    if([step.protocolID isEqualToString:parentId])
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
                if([formSelection.formId isEqualToString:parentId])
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
    }
    return className;
}

-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    __block id obj;
    PFQuery *query;
    NSArray *tableName = [self tableNamesForDataType:dataType];
    //this needs to be refined since some type (eg: component) have more than one associated table
    query = [PFQuery queryWithClassName:[tableName objectAtIndex:0]];
    [query whereKey:@"objectId" equalTo:idString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        {
            if(!error)
                obj= [objects objectAtIndex:0];
        }
    }];
    return obj;
}

-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    PFQuery* query;
    __block BOOL success = NO;
    if([object isKindOfClass:[MedProtocol class]])
    {
        MedProtocol *protocol = (MedProtocol*)object;
        query = [PFQuery queryWithClassName:@"Protocol"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *protocol, NSError *error) {
            {
                if(!error){
                    protocol[@"objectId"] = [protocol objectId];
                    protocol[@"name"] = [protocol name];
                    protocol[@"createdAt"] = [protocol createdAt];
                    protocol[@"updatedAt"] = [protocol updatedAt];
                    [protocol saveInBackground];
                    success = YES;
                }
            }
        }];

    }
    else if([object isKindOfClass:[ProtocolStep class]])
    {
        MedProtocol *protocol = (MedProtocol*)object;
        query = [PFQuery queryWithClassName:@"Step"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *step, NSError *error) {
            {
                if(!error){
                    step[@"objectId"] = protocol.objectId;
                    step[@"stepNumber"] = protocol.;
                    step[@"createdAt"] = [object createdAt];
                    step[@"updatedAt"] = [object updatedAt];
                    step[@"protocolId"] = [object protocolId];
                    [step saveInBackground];
                    success = YES;
                }
            }];
        }
    else if([object isKindOfClass:[Form class]])
    {
        query = [PFQuery queryWithClassName:@"Form"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *form, NSError *error) {
            {
                if(!error){
                    form[@"objectId"] = [object objectId];
                    form[@"updatedAt"] = [object updatedAt];
                    form[@"stepId"] = [object stepId];
                    [form saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[TextBlock class]])
    {
        query = [PFQuery queryWithClassName:@"TextBlock"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *textBlock, NSError *error) {
            {
                if(!error){
                    textBlock[@"objectId"] = [object objectId];
                    textBlock[@"updatedAt"] = [object updatedAt];
                    textBlock[@"printable"] = [NSNumber numberWithBool:[object printable]];
                    textBlock[@"title"] = [object title];
                    textBlock[@"stepId"] = [object stepId];
                    [textBlock saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[Link class]])
    {
        query = [PFQuery queryWithClassName:@"Link"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *link, NSError *error) {
            {
                if(!error){
                    link[@"objectId"] = [object objectId];
                    link[@"updatedAt"] = [object updatedAt];
                    link[@"url"] = [object url];
                    link[@"printable"] = [NSNumber numberWithBool:[object printable]];
                    link[@"label"] = [object label];
                    link[@"stepId"] = [object stepId];
                    [link saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[Calculator class]])
    {
        query = [PFQuery queryWithClassName:@"Calculator"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *calculator, NSError *error) {
            {
                if(!error){
                    calculator[@"objectId"] = [object objectId];
                    calculator[@"updatedAt"] = [object updatedAt];
                    calculator[@"stepId"] = [object stepId];
                    [calculator saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[FormSelection class]])
    {
        query = [PFQuery queryWithClassName:@"FormSelection"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *formSelection, NSError *error) {
            {
                if(!error){
                    formSelection[@"objectId"] = [object objectId];
                    formSelection[@"updatedAt"] = [object updatedAt];
                    formSelection[@"formId"] = [object formId];
                    formSelection[@"label"] = [object label];
                    formSelection[@"choiceA"] = [object choiceA];
                    formSelection[@"choiceB"] = [object choiceB];
                    [formSelection saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    else if([object isKindOfClass:[FormNumber class]])
    {
        query = [PFQuery queryWithClassName:@"FormNumber"];
        [query getObjectInBackgroundWithId:idString block:^(PFObject *formNumber, NSError *error) {
            {
                if(!error){
                    formNumber[@"objectId"] = [object objectId];
                    formNumber[@"updatedAt"] = [object updatedAt];
                    formNumber[@"formId"] = [object formId];
                    formNumber[@"defaultValue"] = [NSNumber numberWithInt:[object defaultValue]];
                    formNumber[@"minValue"] = [NSNumber numberWithInt:[object minValue]];
                    formNumber[@"maxValue"] = [NSNumber numberWithInt:[object maxValue]];
                    formNumber[@"label"] = [object label];
                    [formNumber saveInBackground];
                    success = YES;
                }
            }
        }];
    }
    
    return success;
}

-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}

-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    return NULL;
}
@end
