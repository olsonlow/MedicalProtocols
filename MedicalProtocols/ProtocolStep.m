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
-(NSMutableArray*)components{
    if(_components == nil){
        _components = [[NSMutableArray alloc] init];
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:self.dbPath];
        if(success)
        {
            [db open];
            FMResultSet *results = [db executeQuery:@"", self.objectID];
            while([results next])
            {
                Component *component = [[Component alloc] init];
                [_components addObject:component];
            }
            if ([db hadError]) {
                NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            }
            
            [db close];
        }
    }
    return _components;
}
@end
