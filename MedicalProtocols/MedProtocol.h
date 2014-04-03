//
//  MedProtocol.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;
@class ProtocolStep;
@interface MedProtocol : NSObject
@property(nonatomic,copy) NSString* name;
@property(nonatomic) UIImage* image;
-(id)initWithName:(NSString*)name steps:(NSMutableArray*)steps;
-(id)initWithParseObject:(PFObject*)parseObject;
-(int)countSteps;
-(ProtocolStep*)stepAtIndex:(int)index;

@end
