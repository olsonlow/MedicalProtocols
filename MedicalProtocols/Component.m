//
//  Component.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Component.h"
#import <Parse/Parse.h>
#import "Link.h"
#import "TextBlock.h"
#import "Form.h"
#import "Calculator.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

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
@end
