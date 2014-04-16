//
//  Component.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"
#import "Link.h"
#import "TextBlock.h"
#import "Form.h"
#import "Calculator.h"

@interface Component()

@end

@implementation Component
+(NSString*)ImageNameForComponentType:(ComponentType)componentType{
    NSString* comonentName = @"";
    switch (componentType) {
        case ComponentTypeTextBlock:
            comonentName = @"TextBlockImage.png";
            break;
        case ComponentTypeForm:
            comonentName = @"Form.png";
            break;
        case ComponentTypeCalculator:
            comonentName = @"Calculator.png";
            break;
        case ComponentTypeLink:
            comonentName = @"Link.png";
            break;
            
        default:
            break;
    }
    return comonentName;
}
+(NSString*)NameForComponentType:(ComponentType)componentType{
    NSString* comonentName = @"";
    switch (componentType) {
        case ComponentTypeTextBlock:
            comonentName = @"Text Block";
            break;
        case ComponentTypeForm:
            comonentName = @"Form";
            break;
        case ComponentTypeCalculator:
            comonentName = @"Calculator";
            break;
        case ComponentTypeLink:
            comonentName = @"Link";
            break;
            
        default:
            break;
    }
    return comonentName;
}
-(id)initWithStepId:(NSString*)stepId OrderNumber:(int)orderNumber{
    self = [super init];
    if (self) {
        _stepId = stepId;
        _orderNumber = orderNumber;
    }
    return self;
}
+(id)componentType:(ComponentType)componentType stepId:(NSString*)stepId{
    Component* component = nil;
    switch (componentType) {
        case ComponentTypeTextBlock:
            component = [[TextBlock alloc] init];
            break;
        case ComponentTypeForm:
            component = [[Form alloc] init];
            break;
        case ComponentTypeCalculator:
            component = [[Calculator alloc] init];
            break;
        case ComponentTypeLink:
            component = [[Link alloc] init];
            break;
            
        default:
            break;
    }
    component.stepId = stepId;
    return component;
}
+(void)DeleteComponentWithId:(NSString*)objectId{
    
}
@end
