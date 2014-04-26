//
//  TextEditableProperty.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 24/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "EditableProperty.h"

@interface TextEditableProperty : EditableProperty
@property(nonatomic,assign) BOOL isTextArea;
@property(nonatomic,copy) NSString* value;
@end
