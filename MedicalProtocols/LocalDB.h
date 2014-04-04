//
//  LocalDB.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 3/30/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDB : NSObject
+(LocalDB *) sharedInstance;
-(id) LocalDBInit;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;


@end
