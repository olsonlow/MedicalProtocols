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
#import "TextBlock.h"
#import "Calculator.h"
#import "Link.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"
#import "DataSource.h"

@interface ProtocolStep()
@property (nonatomic,strong) NSMutableArray* components;
@end
@implementation ProtocolStep
-(id)initWithId:(NSString*)objectId stepNumber:(int)stepNumber description:(NSString*)description protocolId:(NSString*)protocolId{
    self = [super init];
    if (self) {
        _description = description;
        _stepNumber = stepNumber;
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
@end
