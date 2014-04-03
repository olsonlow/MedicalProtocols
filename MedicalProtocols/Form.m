//
//  Form.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Form.h"
#import <Parse/Parse.h>
#import "FormNumber.h"
#import "FormSelection.h"

@interface Form()
@property(nonatomic,strong) NSMutableArray* fields;
@end

@implementation Form
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _fields = [[NSMutableArray alloc] init];
        
        PFQuery* query = [PFQuery queryWithClassName:@"FormNumber"];
        [query whereKey:@"step" equalTo:parseObject];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseComponentObject in results) {
                [_fields addObject:[[FormNumber alloc] initWithParseObject:parseComponentObject]];
            }
        }];
        
        query = [PFQuery queryWithClassName:@"FormSelection"];
        [query whereKey:@"step" equalTo:parseObject];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseComponentObject in results) {
                [_fields addObject:[[FormSelection alloc] initWithParseObject:parseComponentObject]];
            }
        }];
    }
    return self;
}
@end
