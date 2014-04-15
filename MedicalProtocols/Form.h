//
//  Form.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"

@interface Form : Component
@property(nonatomic,copy) NSString* stepId;
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,assign) int orderNumber;

-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber;
@end
