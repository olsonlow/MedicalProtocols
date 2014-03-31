//
//  TextBlock.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface TextBlock : NSObject
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* content;
@property(nonatomic,assign) Boolean printable;

-(id)initWithParseObject:(PFObject*)parseObject;

@end
