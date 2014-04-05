//
//  DataSource.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DataType) {
    DataTypeProtocol,
    DataTypeStep,
    DataTypeComponent,
};

@protocol medRefDataSource<NSObject>
-(NSArray*)getAll:(DataType)dataType;
@end

@interface DataSource : NSObject <medRefDataSource>

@end


