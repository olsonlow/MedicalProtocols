//
//  Component.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ComponentType) {
    ComponentTypeTextBlock,
    ComponentTypeLink,
    ComponentTypeCalculator,
    ComponentTypeForm,
    ComponentTypeCount,
};

@interface Component : NSObject
@property(nonatomic,copy) NSString* stepId;
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,assign) int orderNumber;
+(NSString*)ImageNameForComponentType:(ComponentType)componentType;
+(NSString*)NameForComponentType:(ComponentType)componentType;
+(void)DeleteComponentWithId:(NSString*)objectId;

+(int)numberOfEditablePropertiesForComponent;
+(id)componentType:(ComponentType)componentType stepId:(NSString*)stepId;
-(id)initWithObjectId:(NSString*)objectId StepId:(NSString*)stepId OrderNumber:(int)orderNumber;
@end
