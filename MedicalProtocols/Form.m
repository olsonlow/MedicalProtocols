//
//  Form.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Form.h"
#import <Parse/Parse.h>

@interface Form()
@property(nonatomic,strong) NSMutableArray* fields;
@end

@implementation Form
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _fields = [[NSMutableArray alloc] init];
        [parseObject[@"fields"] enumerateObjectsUsingBlock:^(PFObject* parseStepObject,NSUInteger index, BOOL *stop){
            id component = nil;
            
            if([parseStepObject.parseClassName isEqualToString:@"FormNumber"]) {
                //component = [[TextBlock alloc] initWithParseObject:parseStepObject];
            } else if([parseStepObject.parseClassName isEqualToString:@"FormSelection"]){
                //component = [[Link alloc] initWithParseObject:parseStepObject];
            }
            [_fields addObject:component];
        }];
    }
    return self;
}
@end
