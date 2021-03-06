//
//  Calculator.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"

@interface Calculator : Component
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,copy) NSString* stepId;
@property(nonatomic,assign) int orderNumber;

-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber;

@end
