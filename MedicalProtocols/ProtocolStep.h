//
//  ProtocolStep.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocols.h"
#import "Component.h"

@interface ProtocolStep : NSObject
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,assign) int orderNumber;
@property(nonatomic,copy) NSString* protocolId;
@property(nonatomic,strong) NSString* description;

-(id)initWithId:(NSString*)objectId orderNumber:(int)orderNumber description:(NSString*)description protocolId:(NSString*)protocolId;
-(int)countComponents;
-(Component*)componentAtIndex:(int)index;
-(void)removeComponentAtIndex:(int)index;
-(void)addNewComponentWithDataType:(ComponentType)componentType;
@end
