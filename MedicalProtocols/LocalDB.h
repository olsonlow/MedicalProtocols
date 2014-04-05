//
//  LocalDB.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 3/30/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"
@interface LocalDB : NSObject <medRefDataSource>

+(LocalDB *) sharedInstance;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;


@end
