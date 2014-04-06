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
                if([className isEqual:@"Protocol"])
                    [parseObjects addObject:[[MedProtocol alloc] initWithParseObject:object]];
                else if([className isEqual:@"Step"])
                    [parseObjects addObject:[[ProtocolStep alloc] initWithParseObject:object]];
                else if([className isEqual:@"Form"])
                    [parseObjects addObject:[[Form alloc]initWithParseObject:object]];
                else if([className isEqual:@"Link"])
                    [parseObjects addObject:[[Link alloc]initWithParseObject:object]];
                else if([className isEqual:@"Calculator"])
                    [parseObjects addObject:[[Calculator alloc]initWithParseObject:object]];
                else if([className isEqual:@"TextBlock"])
                    [parseObjects addObject:[[TextBlock alloc]initWithParseObject:object]];
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

+(ParseDataSource *)sharedInstance
{
    static ParseDataSource* sharedObject = nil;
    if(sharedObject == nil)
        sharedObject = [[ParseDataSource alloc] init];
    return sharedObject;
}
@end
