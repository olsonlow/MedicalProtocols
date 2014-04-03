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

@interface ProtocolStep()
@property (nonatomic,strong) NSMutableArray* components;
@property (nonatomic) Component* component;

@end

@implementation ProtocolStep
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
//-(void)initComponentsFromDBForStepID:(NSString*)objectID{
//    NSString *dbPath = @"medRef.db";
//    self.components = [[NSMutableArray alloc] init];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    [db open];
//    FMResultSet *results = [db executeQuery:@"SELECT * FROM step"];
//    while([results next])
//    {
//        ProtocolStep *step = [[ProtocolStep alloc] init];
//        step.stepNumber = [results intForColumn:@"stepNumber"];
//        [self.step initComponentsFromDBForStepID:[results stringForColumn:@"objectID"]];
//        [self.steps addObject:step];
//    }
//    [db close];
//}
@end
