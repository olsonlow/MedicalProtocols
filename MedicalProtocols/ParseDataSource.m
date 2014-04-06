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

-(NSArray*)getAll:(DataType)dataType{
    
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
                if([className isEqual:@"Protocol"]){
                    MedProtocol *protocol = [[MedProtocol alloc]init];
                    protocol.name = object[@"name"];
                    protocol.createdAt = object[@"createdAt"];
                    protocol.updatedAt = object[@"updatedAt"];
                    protocol.idStr = object[@"objectID"];
                    [parseObjects addObject:protocol];
                }
                else if([className isEqual:@"Step"]){
                    ProtocolStep *step = [[ProtocolStep alloc]init];
                    step.objectID = object[@"objectId"];
                    step.stepNumber = [object[@"stepNumber"]intValue];
                    step.createdAt = object[@"createdAt"];
                    step.updatedAt = object[@"updatedAt"];
                    step.protocolID = object[@"protocol"];
                    step.description = object[@"description"];
                    [parseObjects addObject:step];
                }
                else if([className isEqual:@"Form"]){
                    Form *form = [[Form alloc]init];
                    form.formId = object[@"objectId"];
                    form.stepId = object[@"stepId"];
                    form.createdAt = object[@"createdAt"];
                    form.updatedAt = object[@"updatedAt"];
                    [parseObjects addObject:form];
                }
                else if([className isEqual:@"Link"]){
                    Link *link = [[Link alloc]init];
                    link.label = object[@"label"];
                    link.url = object[@"url"];
                    link.linkId = object[@"objectId"];
                    link.stepId = object[@"stepId"];
                    link.createdAt = object[@"createdAt"];
                    link.updatedAt = object[@"updatedAt"];
                    link.printable = [object[@"printable"]boolValue];
                    [parseObjects addObject:link];
                }
                else if([className isEqual:@"Calculator"]){
                    Calculator *calculator = [[Calculator alloc]init];
                    calculator.calculatorId = object[@"objectId"];
                    calculator.stepId = object[@"stepId"];
                    calculator.createdAt = object[@"createdAt"];
                    calculator.updatedAt = object[@"updatedAt"];
                    [parseObjects addObject:calculator];
                }
                else if([className isEqual:@"TextBlock"]){
                    TextBlock *textBlock = [[TextBlock alloc]init];
                    textBlock.title = object[@"title"];
                    textBlock.content = object[@"content"];
                    textBlock.printable = [object[@"printable"]boolValue];
                    textBlock.textBlockId = object[@"objectId"];
                    textBlock.stepId = object[@"stepId"];
                    textBlock.createdAt = object[@"createdAt"];
                    textBlock.updatedAt = object[@"updatedAt"];
                    [parseObjects addObject:textBlock];
                }
                else if([className isEqual:@"FormNumber"]){
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

-(NSMutableArray*)getStepComponents{
    NSArray *parseClassNames = @[@"Form", @"Link", @"Calculator", @"TextBlock"];
    NSMutableArray* stepComponents = [[NSMutableArray alloc]  init];
    for(NSString* className in parseClassNames){
        [stepComponents addObjectsFromArray:[self getAllFromParseClassNamed:className]];
    }
    return stepComponents;
    
}

-(NSMutableArray*)getFormComponents{
    NSArray* parseClassNames = @[@"FromNumber",@"FormSelection"];
    NSMutableArray* formComponents = [[NSMutableArray alloc]  init];
    for(NSString* className in parseClassNames){
        [formComponents addObjectsFromArray:[self getAllFromParseClassNamed:className]];
    }
    return formComponents;
}

-(NSArray*)getAll:(DataType)dataType withParentId:(NSString*)parentId{
    return NULL;
}

-(bool)updateDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    return NULL;
}

-(bool)deleteDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}

-(bool)insertDataType:(DataType)dataType withObject:(id)object{
    return NULL;
}

-(bool)getObjectDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}
@end
