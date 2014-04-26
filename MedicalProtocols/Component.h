//
//  Component.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EditableProperty;
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
@property(nonatomic,assign) ComponentType componentType;
@property (nonatomic,strong) NSMutableArray* editableProperties;

+(NSString*)ImageNameForComponentType:(ComponentType)componentType;
+(NSString*)NameForComponentType:(ComponentType)componentType;
+(void)DeleteComponentWithId:(NSString*)objectId;

-(int)countEditableProperties;
-(EditableProperty*)editablePropertyAtIndex:(int)index;
+(id)componentType:(ComponentType)componentType stepId:(NSString*)stepId;
-(id)initWithObjectId:(NSString*)objectId StepId:(NSString*)stepId OrderNumber:(int)orderNumber componentType:(ComponentType)componentType;
@end
