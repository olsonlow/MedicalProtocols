//
//  Link.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Link.h"

@implementation Link
-(id)initWithLabel:(NSString*)label url:(NSString*)url objectId:(NSString*)objectId stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super initWithStepId:stepId OrderNumber:orderNumber];
    if (self) {
        _label = label;
        _url = url;
        _objectId = objectId;
    }
    return self;
}
-(instancetype)init{
    return [self initWithLabel:@"" url:@"" objectId:@"" stepId:@"" orderNumber:-1];
}
@end
