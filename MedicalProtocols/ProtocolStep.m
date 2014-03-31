//
//  ProtocolStep.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolStep.h"
#import <Parse/Parse.h>
#import "Link.h"
#import "TextBlock.h"
#import "Form.h"
#import "Calculator.h"

@interface ProtocolStep()
@property (nonatomic,strong) NSMutableArray* components;

@end

@implementation ProtocolStep
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _stepNumber = [parseObject[@"stepNumber"] intValue];
        _description = parseObject[@"description"];
        _components = [[NSMutableArray alloc] init];
        [parseObject[@"steps"] enumerateObjectsUsingBlock:^(PFObject* parseStepObject,NSUInteger index, BOOL *stop){
            id component = nil;
            
            if([parseStepObject.parseClassName isEqualToString:@"TextBlock"]) {
                component = [[TextBlock alloc] initWithParseObject:parseStepObject];
            } else if([parseStepObject.parseClassName isEqualToString:@"Link"]){
                component = [[Link alloc] initWithParseObject:parseStepObject];
            } else if([parseStepObject.parseClassName isEqualToString:@"Calculator"]){
                component = [[Calculator alloc] initWithParseObject:parseStepObject];
            } else if([parseStepObject.parseClassName isEqualToString:@"Form"]){
                component = [[Form alloc] initWithParseObject:parseStepObject];
            }
            [_components addObject:component];
        }];
    }
    return self;
}
@end
