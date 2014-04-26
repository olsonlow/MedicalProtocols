//
//  FormNumber.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormComponent.h"

@interface FormNumber : FormComponent
@property(nonatomic,copy) NSString* label;
@property(nonatomic,assign) int defaultValue;
@property(nonatomic,assign) int maxValue;
@property(nonatomic,assign) int minValue;
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,copy) NSString* formId;
@property(nonatomic,assign) int orderNumber;

-(id)initWithLabel:(NSString*)label defaultValue:(int)defaultValue minValue:(int)minValue maxValue:(int)maxValue objectId:(NSString*)objectId orderNumber:(int)orderNumber formId:(NSString*)formId;

@end
