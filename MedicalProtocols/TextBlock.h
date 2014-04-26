//
//  TextBlock.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"

@interface TextBlock : Component
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* content;
@property(nonatomic,assign) Boolean printable;
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,copy) NSString* stepId;

-(id)initWithTitle:(NSString*)title content:(NSString*)content printable:(bool)printable objectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber;


@end
