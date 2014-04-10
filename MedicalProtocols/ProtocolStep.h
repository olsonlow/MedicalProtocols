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
@property(nonatomic) NSString* dbPath;
@property(nonatomic,assign) int objectId;
@property(nonatomic,assign) int stepNumber;
@property(nonatomic,assign) int protocolId;
@property(nonatomic,strong) NSString* description;

-(id)initWithId:(int)objectId stepNumber:(int)stepNumber description:(NSString*)description protocolId:(int)protocolId;


@end
