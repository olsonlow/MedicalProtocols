//
//  MedProtocol.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProtocolStep;
@interface MedProtocol : NSObject
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* objectId;
-(id)initWithName:(NSString*)name objectId:(NSString*)objectId;
-(int)countSteps;
-(ProtocolStep*)stepAtIndex:(int)index;
-(void)removeStepAtIndex:(int)index;
-(void)addNewStep;
@end
