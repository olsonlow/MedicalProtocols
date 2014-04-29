//
//  ParseDataSource.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
// This datasource interfaces with parse.com to store and share protocols created by this app, see documentation
// in ParseDataSource.m file for more details

#import <Foundation/Foundation.h>
#import "DataSourceProtocols.h"


@interface ParseDataSource : NSObject<MedRefDataSource>
+(ParseDataSource *) sharedInstance;
+(ParseDataSource *) sharedInstanceWithDelegate:(id<ParseDataDownloadedDelegate>)delegate;
-(void)downloadAllTablesFromParse;
@property(nonatomic,assign,readonly) bool dataSourceReady;
@property(nonatomic,weak) id<ParseDataDownloadedDelegate> delegate;
@end