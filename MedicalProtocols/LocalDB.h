//
//  LocalDB.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 3/30/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocols.h"
@interface LocalDB : NSObject <MedRefDataSource>
-(NSString *) tableNameForObject:(id) object;
+(LocalDB *) sharedInstance;
+(LocalDB *) sharedInstanceWithDelegate:(id<LocalDBReadyForUseDelegate>)delegate;
@property(nonatomic,assign,readonly) bool dataSourceReady;
@property(nonatomic,weak) id<LocalDBReadyForUseDelegate> delegate;
@end
