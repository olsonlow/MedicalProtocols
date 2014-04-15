//
//  FormSelection.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"
@class PFObject;
@interface FormSelection : Component
@property(nonatomic,copy) NSString* label;
@property(nonatomic,copy) NSString* choiceA;
@property(nonatomic,copy) NSString* choiceB;
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,copy) NSString* formId;
@property(nonatomic,assign) int orderNumber;

-(id)initWithLabel:(NSString*)label choiceA:(NSString*)choiceA choiceB:(NSString*)choiceB objectId:(NSString*)objectId orderNumber:(int)orderNumber formId:(NSString*)formId;

@end
