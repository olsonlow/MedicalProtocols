//
//  Link.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface Link : NSObject
@property(nonatomic,copy) NSString* label;
@property(nonatomic,copy) NSString* url;
@property(nonatomic, assign) int objectId;
@property(nonatomic, assign) int stepId;
@property(nonatomic) BOOL printable;

-(id)initWithLabel:(NSString*)label url:(NSString*)url objectId:(int)objectId stepId:(int)stepId;

@end
