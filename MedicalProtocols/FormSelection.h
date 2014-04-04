//
//  FormSelection.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;
@interface FormSelection : NSObject
@property(nonatomic,copy) NSString* label;
@property(nonatomic,copy) NSString* choiceA;
@property(nonatomic,copy) NSString* choiceB;
@property(nonatomic) NSDate *createdAt;
@property(nonatomic) NSDate *updatedAt;
@property(nonatomic) NSString *formSeletionId;
@property(nonatomic) NSString *formId;

-(id)initWithParseObject:(PFObject*)parseObject;

@end
