//
//  Calculator.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface Calculator : NSObject

@property(nonatomic) NSString* objectId;
@property(nonatomic) NSString* stepId;
@property(nonatomic) NSDate *createdAt;
@property(nonatomic) NSDate *updatedAt;

-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId;
-(id)initWithParseObject:(PFObject*)parseObject;
-(id)initWithDBObject:(NSObject*)DBObject;
@end
