//
//  MedProtocol.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
//  Med Protocol and other sprotocol objects should only be modified if the object requires
//  A new property, or if the parent object needs to be able to modify a child object.
//  Any modifications made to any sprotocol object, especially any new properties or any
//  additional information that will be stored in the databases will require modifications to the database
//  files.  Proceed with caution before making any modifications to these objects.

#import "MedProtocol.h"
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
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderNumber" ascending:YES];
        [_steps sortUsingDescriptors:@[sortDescriptor]];
        
    }
    return _steps;
}
-(void)removeStepAtIndex:(int)index{
    ProtocolStep* step = [self.steps objectAtIndex:index];
    [[DataSource sharedInstance] deleteObjectWithDataType:DataTypeStep withId:step.objectId isChild:NO];
    [step removeComponents];
    [self.steps removeObjectAtIndex:index];
}

-(void)addNewStep{
    ProtocolStep* newStep = [[ProtocolStep alloc] initWithId:[[[NSUUID alloc] init] UUIDString] orderNumber:-1 descript:@"New Step" protocolId:self.objectId];
    [self.steps addObject:newStep];
    newStep.orderNumber = [self.steps indexOfObject:newStep];
    [[DataSource sharedInstance] insertObjectWithDataType:DataTypeProtocol withObject:newStep];
}
-(int)countSteps{
    return [self.steps count];
}
-(ProtocolStep*)stepAtIndex:(int)index{
    return [self.steps objectAtIndex:index];
}

@end
