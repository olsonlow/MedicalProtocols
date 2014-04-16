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
@property(nonatomic,assign) int orderNumber;
+(NSString*)ImageNameForComponentType:(ComponentType)componentType;
+(NSString*)NameForComponentType:(ComponentType)componentType;
-(id)initWithComponentType:(ComponentType)componentType;
@end
