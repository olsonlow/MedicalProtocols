//
//  ProtocolStep.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolStep.h"
#import <Parse/Parse.h>

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
    }
    return self;
}
@end
