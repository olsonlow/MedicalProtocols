//
//  DataSource.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol medRefDataSource<NSObject>

-(NSArray*)getAllProtocols;
-(NSArray*)getStepsForProtocolId:(NSString*)protocolId;
-(NSArray*)getComponentsForStepId:(NSString*)stepId;

@end

@interface DataSource : NSObject <medRefDataSource>
-(NSArray*)getAllProtocols;
-(NSArray*)getStepsForProtocolId:(NSString*)protocolId;
-(NSArray*)getComponentsForStepId:(NSString*)stepId;

@end


