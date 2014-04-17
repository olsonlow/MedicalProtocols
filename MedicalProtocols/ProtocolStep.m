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
#import "DataSource.h"

@interface ProtocolStep()
@property (nonatomic,strong) NSMutableArray* components;
@end
@implementation ProtocolStep
-(id)initWithId:(NSString*)objectId orderNumber:(int)orderNumber description:(NSString*)description protocolId:(NSString*)protocolId{
    self = [super init];
    if (self) {
        _description = description;
        _orderNumber = orderNumber;
        _objectId = objectId;
        _protocolId = protocolId;
    }
    
    return self;
}

-(NSMutableArray*)components{
    if(_components == nil){
        _components = [[NSMutableArray alloc] init];
        [_components addObjectsFromArray:[[DataSource sharedInstance]getAllObjectsWithDataType: DataTypeComponent withParentId:self.objectId]];

    }
    return _components;
}
-(int)countComponents{
    return [self.components count];
}

-(Component*)componentAtIndex:(int)index{
    return [self.components objectAtIndex:index];
}
-(void)removeComponentAtIndex:(int)index{
    [[DataSource sharedInstance] deleteObjectWithDataType:DataTypeComponent withId:[self.components objectAtIndex:index] isChild:NO];
    [self.components removeObjectAtIndex:index];
}

-(void) removeComponents
{
    [[DataSource sharedInstance]deleteObjectWithDataType:DataTypeComponent withId:self.objectId isChild:YES]; //remove all componenets associated to this step's objectId
    [self.components removeAllObjects];
}
-(void)addNewComponentWithComponentType:(ComponentType)componentType{
    [self addNewComponentWithComponentType:componentType atIndex:[self.components count]];
}
-(void)addNewComponentWithComponentType:(ComponentType)componentType atIndex:(int)index{
    Component* newComponent = [Component componentType:componentType stepId:self.objectId];
    [self.components insertObject:newComponent atIndex:index];
    newComponent.orderNumber = [self.components indexOfObject:newComponent];
    [[DataSource sharedInstance] insertObjectWithDataType:DataTypeComponent withObject:newComponent];
}
@end
