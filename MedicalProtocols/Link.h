//
//  Link.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"

@interface Link : Component
@property(nonatomic,copy) NSString* label;
@property(nonatomic,copy) NSString* url;
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,copy) NSString* stepId;

-(id)initWithLabel:(NSString*)label url:(NSString*)url objectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber;

@end
