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
@property(nonatomic) NSDate *createdAt;
@property(nonatomic) NSDate *updatedAt;
@property(nonatomic) NSString *stepId;
@property(nonatomic) NSString *formId;

-(id)initWithParseObject:(PFObject*)parseObject;
@end
