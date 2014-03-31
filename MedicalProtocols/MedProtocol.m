//
//  MedProtocol.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "MedProtocol.h"
#import <Parse/Parse.h>
#import "ProtocolStep.h"

@interface MedProtocol()
@property (nonatomic,strong) NSMutableArray* steps;

@end

@implementation MedProtocol
- (id)initWithName:(NSString*)name steps:(NSMutableArray*)steps
{
    self = [super init];
    if (self) {
        _name = name;
        _steps = steps;
    }
    return self;
}

-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _name = parseObject[@"name"];
        _steps = [[NSMutableArray alloc] init];
        _image = parseObject[@"protocolImage"];
        [parseObject[@"steps"] enumerateObjectsUsingBlock:^(id parseStepObject,NSUInteger index, BOOL *stop){
            [_steps addObject:[[ProtocolStep alloc] initWithParseObject:parseStepObject]];
        }];
    }
    return self;
}
@end
