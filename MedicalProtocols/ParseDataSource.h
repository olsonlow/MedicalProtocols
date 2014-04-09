//
//  ParseDataSource.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocols.h"


@interface ParseDataSource : NSObject<MedRefDataSource>
+(ParseDataSource *) sharedInstance;
+(ParseDataSource *) sharedInstanceWithDelegate:(id<ParseDataDownloadedDelegate>)delegate;
@property(nonatomic,assign) bool dataSourceReady;
@property(nonatomic,weak) id<ParseDataDownloadedDelegate> delegate;
@end