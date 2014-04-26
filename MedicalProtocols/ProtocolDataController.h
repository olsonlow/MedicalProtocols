//
//  ProtocolDataController.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocols.h"

@class MedProtocol;
@interface ProtocolDataController : NSObject<MedRefDataSourceDelegate>
@property (readonly,assign, nonatomic) bool dataSourceReady;
-(int)countProtocols;
-(void)createNewProtocol;
-(MedProtocol*)protocolAtIndex:(int)index;
-(void)removeProtocolAtIndex:(int)index;
-(id)initWithDelegate:(id<MedRefDataSourceDelegate>)delegate;
@end
