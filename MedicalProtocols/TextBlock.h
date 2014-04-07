//
//  TextBlock.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface TextBlock : NSObject
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* content;
@property(nonatomic,assign) Boolean printable;
@property(nonatomic) NSString* objectId;
@property(nonatomic) NSString* stepId;
@property(nonatomic) NSDate *createdAt;
@property(nonatomic) NSDate *updatedAt;

-(id)initWithTitle:(NSString*)title content:(NSString*)content printable:(bool)printable objectId:(NSString*)objectId stepId:(NSString*)stepId;
-(id)initWithParseObject:(PFObject*)parseObject;
-(id)initWithDBObject:(NSObject*)DBObject;

@end
