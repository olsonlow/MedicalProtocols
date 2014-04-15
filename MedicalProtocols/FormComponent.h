//
//  FormComponent.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormComponent : NSObject
@property(nonatomic,copy) NSString* formId;
@property(nonatomic,copy) NSString* label;
-(id) initWithLabel:(NSString *)label objectId: (NSString *) objectId formId:(NSString *)formId;
-(id) initFormComponentKindFromObject:(id)object;
@end
