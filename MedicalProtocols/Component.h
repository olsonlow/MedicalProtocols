//
//  Component.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface Component : NSObject
@property(nonatomic) NSString* dbPath;
+(NSMutableArray*)componentsForStepParseObject:(PFObject*)parseObject;


@end
