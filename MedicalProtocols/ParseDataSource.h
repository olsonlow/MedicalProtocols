//
//  ParseDataSource.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"


@interface ParseDataSource : NSObject<medRefDataSource>
+(ParseDataSource *) sharedInstance;
@end
