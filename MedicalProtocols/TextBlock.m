//
//  TextBlock.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "TextBlock.h"
#import <Parse/Parse.h>

@implementation TextBlock
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _title = parseObject[@"title"];
        _content = parseObject[@"content"];
        _printable = [parseObject[@"printable"] boolValue];
    }
    return self;
}
@end
