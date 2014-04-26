//
//  EditableProperty.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 24/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditableProperty : NSObject
@property (nonatomic,copy) NSString* name;
-(id)initWithName:(NSString*)name;
@end
