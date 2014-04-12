//
//  Form.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface Form : NSObject
@property(nonatomic,copy) NSString* stepId;
@property(nonatomic,copy) NSString* objectId;

-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId;
@end
