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

@property(nonatomic, assign) int objectId;
@property(nonatomic, assign) int stepId;

-(id)initWithObjectId:(int)objectId stepId:(int)stepId;

@end
