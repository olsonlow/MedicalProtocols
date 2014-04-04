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
@property(nonatomic) NSString* linkId;
@property(nonatomic) NSString* stepId;
@property(nonatomic) NSDate *createdAt;
@property(nonatomic) NSDate *updatedAt;
@property(nonatomic) BOOL printable;

-(id)initWithParseObject:(PFObject*)parseObject;
-(id)initWithDBObject:(NSObject*)DBObject;

@end
