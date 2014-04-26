//
//  Link.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Link.h"
#import "TextEditableProperty.h"

@implementation Link
-(id)initWithLabel:(NSString*)label url:(NSString*)url objectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super initWithObjectId:objectId StepId:stepId OrderNumber:orderNumber componentType:ComponentTypeLink];
    if (self) {
        _label = label;
        _url = url;
    }
    return self;
}
-(void)setUrl:(NSString *)url{
    NSRange range = [url rangeOfString:@"http://"];
    
    if (range.location == NSNotFound) {
        _url = [NSString stringWithFormat:@"http://%@",url];
    } else {
        _url = url;
    }
}
-(instancetype)init{
    return [self initWithLabel:@"" url:@"" objectId:[[[NSUUID alloc] init] UUIDString] stepId:@"" orderNumber:-1];
}
-(NSMutableArray *)editableProperties{
    NSMutableArray* editableProperties = super.editableProperties;
    if(!editableProperties){
        editableProperties = [[NSMutableArray alloc] init];
        TextEditableProperty* labelProperty = [[TextEditableProperty alloc] init];
        labelProperty.name = @"Label";
        labelProperty.isTextArea = NO;
        labelProperty.value = self.label;
        [editableProperties addObject:labelProperty];
        
        TextEditableProperty* urlProperty = [[TextEditableProperty alloc] init];
        urlProperty.name = @"url";
        urlProperty.isTextArea = NO;
        urlProperty.value = self.url;
        [editableProperties addObject:urlProperty];
        
    }
    return editableProperties;
}
@end
