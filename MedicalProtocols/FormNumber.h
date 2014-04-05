//
//  FormNumber.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;
@interface FormNumber : NSObject
@property(nonatomic,copy) NSString* label;
@property(nonatomic,assign) int defaultValue;
@property(nonatomic,assign) int maxValue;
@property(nonatomic,assign) int minValue;
@property(nonatomic) NSDate *createdAt;
@property(nonatomic) NSDate *updatedAt;
@property(nonatomic) NSString *formNumberId;
@property(nonatomic) NSString *formId;

-(id)initWithParseObject:(PFObject*)parseObject;

@end
