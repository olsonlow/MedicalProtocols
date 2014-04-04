//
//  Component.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"
#import <Parse/Parse.h>
#import "Link.h"
#import "TextBlock.h"
#import "Form.h"
#import "Calculator.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface Component()
{
 NSString* dbPath;
}

@end


@implementation Component
+(NSMutableArray*)componentsForStepParseObject:(PFObject*)parseObject{
    NSMutableArray* components = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TextBlock"];
    [query whereKey:@"step" equalTo:parseObject];

    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        for (PFObject* parseComponentObject in results) {
            [components addObject:[[TextBlock alloc] initWithParseObject:parseComponentObject]];
        }
    }];

    query = [PFQuery queryWithClassName:@"Form"];
    [query whereKey:@"step" equalTo:parseObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        for (PFObject* parseComponentObject in results) {
            [components addObject:[[Form alloc] initWithParseObject:parseComponentObject]];
        }
    }];

    query = [PFQuery queryWithClassName:@"Calculator"];
    [query whereKey:@"step" equalTo:parseObject];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        for (PFObject* parseComponentObject in results) {
            [components addObject:[[Calculator alloc] initWithParseObject:parseComponentObject]];
        }
    }];

    query = [PFQuery queryWithClassName:@"Link"];
    [query whereKey:@"step" equalTo:parseObject];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        for (PFObject* parseComponentObject in results) {
            [components addObject:[[Link alloc] initWithParseObject:parseComponentObject]];
        }
    }];

    return components;
}
//-(id)initWithDatabaseObject:(NSObject*) databaseObject{
//    
//    
//    return self;
//}
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
//        _name = parseObject[@"name"];
    }
    return self;
}
@end
