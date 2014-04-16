//
//  FormComponent.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormComponent : NSObject
@property(nonatomic,copy) NSString* label;
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,copy) NSString* formId;
@property(nonatomic,assign) int orderNumber;

-(id)initWithFormId:(NSString*)formId orderNumber:(int)orderNumber label:(NSString*)label;
@end
