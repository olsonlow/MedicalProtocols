//
//  ProtocolStep.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolStep.h"
#import <Parse/Parse.h>
#import "Component.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "TextBlock.h"
#import "Calculator.h"
#import "Link.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"

@interface ProtocolStep()
@property (nonatomic,strong) NSMutableArray* components;

@end
@implementation ProtocolStep
-(id)initWithId:(NSString*)objectId stepNumber:(int)stepNumber description:(NSString*)description protocolId:(NSString*)protocolId{
    self = [super init];
    if (self) {
        _description = description;
        _stepNumber = stepNumber;
        _objectId = objectId;
        _protocolID = protocolId;
    }
    
    return self;
}
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _description = parseObject[@"description"];
        _stepNumber = [parseObject[@"stepNumber"] intValue];
        _components = [Component componentsForStepParseObject:parseObject];
        
//        [parseObject[@"components"] enumerateObjectsUsingBlock:^(id parseComponentObject,NSUInteger index, BOOL *stop){
//            [_components addObject:[[ProtocolStep alloc] initWithParseObject:parseComponentObject]];
//        }];
//        
//        PFQuery *query = [PFQuery queryWithClassName:@"Component"];
//        [query whereKey:@"protocol" equalTo:parseObject];
//        [PFObject fetchAllIfNeededInBackground:parseObject[@"components"] block:^(NSArray *objects, NSError *error){
//            [objects enumerateObjectsUsingBlock:^(PFObject* parseStepObject,NSUInteger index, BOOL *stop){
//                id component = nil;
//                if([parseStepObject.parseClassName isEqualToString:@"TextBlock"]) {
//                    component = [[TextBlock alloc] initWithParseObject:parseStepObject];
//                } else if([parseStepObject.parseClassName isEqualToString:@"Link"]){
//                    component = [[Link alloc] initWithParseObject:parseStepObject];
//                } else if([parseStepObject.parseClassName isEqualToString:@"Calculator"]){
//                    component = [[Calculator alloc] initWithParseObject:parseStepObject];
//                } else if([parseStepObject.parseClassName isEqualToString:@"Form"]){
//                    component = [[Form alloc] initWithParseObject:parseStepObject];
//                }
//                [_components addObject:component];
//            }];
//        }];

        
//        [parseObject[@"components"] enumerateObjectsUsingBlock:^(PFObject* parseStepObject,NSUInteger index, BOOL *stop){
//            id component = nil;
//            
//            if([parseStepObject.parseClassName isEqualToString:@"TextBlock"]) {
//                component = [[TextBlock alloc] initWithParseObject:parseStepObject];
//            } else if([parseStepObject.parseClassName isEqualToString:@"Link"]){
//                component = [[Link alloc] initWithParseObject:parseStepObject];
//            } else if([parseStepObject.parseClassName isEqualToString:@"Calculator"]){
//                component = [[Calculator alloc] initWithParseObject:parseStepObject];
//            } else if([parseStepObject.parseClassName isEqualToString:@"Form"]){
//                component = [[Form alloc] initWithParseObject:parseStepObject];
//            }
//            [_components addObject:component];
//        }];
    }
    
    return self;
}
-(NSMutableArray*)components{
    if(_components == nil){
        _components = [[NSMutableArray alloc] init];
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:self.dbPath];
        NSArray *componentList = [NSArray arrayWithObjects: @"textblock", @"calculator", @"link", @"form",nil];

        if(success)
        {
            [db open];
            for(NSString* componentName in componentList){
                FMResultSet *results = [db executeQuery:@"Select * from ? where stepID = ?",componentName, self.objectId];
                while([results next])
                {
                    if ([componentName isEqualToString: @"textblock"]) {
                        TextBlock *textBlock = [[TextBlock alloc] initWithTitle:[results stringForColumn:@"title"] content:[results stringForColumn:@"content"]  printable:[results boolForColumn:@"printable"] objectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:textBlock];
                    }
                    else if([componentName isEqualToString:@"calculator"]){
                        Calculator *calculator = [[Calculator alloc] initWithObjectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:calculator];
                    }
                    else if([componentName isEqualToString:@"link"]){
                        Link *link = [[Link alloc] initWithLabel:[results stringForColumn:@"label"] url:[results stringForColumn:@"url"] objectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:link];
                    }else{
                        Form *form = [[Form alloc]initWithObjectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:form];
                        
                    }
                }
                if ([db hadError]) {
                    NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
            }
            [db close];
        }
    }
    return _components;
}
@end
