//
//  EditableProperty.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 24/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "EditableProperty.h"

@implementation EditableProperty
-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}
@end
