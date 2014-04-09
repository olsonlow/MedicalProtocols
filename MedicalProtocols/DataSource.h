//
//  DataSource.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocols.h"

@interface DataSource : NSObject <MedRefDataSource,ParseDataDownloadedDelegate,LocalDBReadyForUseDelegate>

@property(nonatomic,assign) bool dataSourceReady;
@property(nonatomic,assign) id<MedRefDataSourceDelegate> medRefDataSourceDelegate;

@end


