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
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType;
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(NSString*)parentId;
-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object;
-(bool)deleteObjectWithDataType:(DataType)dataType withParentId: (NSString *)idString;
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)idString;
-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object;
-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)idString;
@end

@interface DataSource : NSObject <medRefDataSource>

@end


