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
    DataTypeFormComponent,
};

@protocol medRefDataSource<NSObject>
-(NSArray*)getAll:(DataType)dataType;
-(NSArray*)getAll:(DataType)dataType withParentId:(NSString*)parentId;
-(bool)updateDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object;
-(bool)deleteDataType:(DataType)dataType withId:(NSString*)idString;
-(bool)insertDataType:(DataType)dataType withObject:(id)object;
-(id)getObjectDataType:(DataType)dataType withId:(NSString*)idString;
@end

@interface DataSource : NSObject <medRefDataSource>

@end


