//
//  ProtocolDataController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocols.h"

@class MedProtocol;
@interface ProtocolDataController : NSObject<MedRefDataSourceDelegate>
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;
-(int)countProtocols;
-(MedProtocol*)protocolAtIndex:(int)index;

@end
