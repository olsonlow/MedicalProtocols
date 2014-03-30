//
//  ProtocolStep.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;
@interface ProtocolStep : NSObject
@property(nonatomic,assign) int stepNumber;
@property(nonatomic,strong) NSString* description;

-(id)initWithParseObject:(PFObject*)parseObject;

@end
