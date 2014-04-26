//
//  TextBlock.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "TextBlock.h"
#import "TextEditableProperty.h"
#import "TextEditableProperty.h"

@implementation TextBlock
-(id)initWithTitle:(NSString*)title content:(NSString*)content printable:(bool)printable objectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super initWithObjectId:objectId StepId:stepId OrderNumber:orderNumber componentType:ComponentTypeTextBlock];
    if (self) {
        _title = title;
        _content = content;
        _printable = printable; 
    }
    return self;
}
- (instancetype)init
{
    return [self initWithTitle:@"" content:@"" printable:NO objectId:[[[NSUUID alloc] init] UUIDString]  stepId:@"" orderNumber:-1];
}
-(NSMutableArray *)editableProperties{
    NSMutableArray* editableProperties = super.editableProperties;
    if(!editableProperties){
        editableProperties = [[NSMutableArray alloc] init];
        TextEditableProperty* textProperty = [[TextEditableProperty alloc] init];
        textProperty.name = @"Title";
        textProperty.isTextArea = NO;
        [editableProperties addObject:textProperty];
        
        TextEditableProperty* textAreaProperty = [[TextEditableProperty alloc] init];
        textAreaProperty.name = @"Content";
        textAreaProperty.isTextArea = YES;
        [editableProperties addObject:textAreaProperty];
        
    }
    return editableProperties;
}
@end
