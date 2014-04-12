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
@property(nonatomic,copy) NSString* objectId;
@property(nonatomic,assign) int stepNumber;
@property(nonatomic,copy) NSString* protocolId;
@property(nonatomic,strong) NSString* description;
@property (nonatomic) NSUUID* nsuuid;

-(id)initWithId:(NSString*)objectId stepNumber:(int)stepNumber description:(NSString*)description protocolId:(NSString*)protocolId;


@end
