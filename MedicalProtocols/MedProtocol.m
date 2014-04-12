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
#import "DataSource.h"

@interface MedProtocol()
@property (nonatomic,strong) NSMutableArray* steps;
@property (nonatomic) ProtocolStep* step;

@end

@implementation MedProtocol

-(id)initWithName:(NSString*)name objectId:(NSString*)objectId{
    self = [super init];
    if (self) {
        _name = name;
        _objectId = objectId;
    }
    return self;
}

-(NSMutableArray *)steps{
    if(_steps == nil){
        _steps = [[NSMutableArray alloc] init];
        [_steps addObjectsFromArray:[[DataSource sharedInstance] getAllObjectsWithDataType:DataTypeStep withParentId:self.objectId]];
        
    }
    return _steps;
}
-(int)countSteps{
    return [self.steps count];
}
-(ProtocolStep*)stepAtIndex:(int)index{
    return [self.steps objectAtIndex:index];
}

@end
