//
//  Link.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Link.h"
#import <Parse/Parse.h>

@implementation Link
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _label = parseObject[@"label"];
        _url = parseObject[@"url"];
    }
    return self;
}
@end
