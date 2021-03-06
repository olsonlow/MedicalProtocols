//
//  DataSourceProtocols.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 8/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DataType) {
    DataTypeProtocol,
    DataTypeStep,
    DataTypeComponent,
    DataTypeFormComponent,
};

@protocol MedRefDataSourceDelegate<NSObject>
-(void)dataSourceReadyForUse;
@end

@protocol MedRefDataSource<NSObject>
-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)objectId;
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType;
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(NSString*)parentId;
-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)objectId withObject:(id)object;
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)objectId isChild:(bool)isChild;
-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object;
@optional
@property(nonatomic,assign,readonly) bool dataSourceReady;
@property(nonatomic,assign) id<MedRefDataSourceDelegate> medRefDataSourceDelegate;
@end

@protocol ParseDataDownloadedDelegate<NSObject>
-(void)downloadedParseObject:(id)parseObject withDataType:(DataType)datatype;
-(void)downloadedParseObjects:(NSArray*)parseObjects withDataType:(DataType)datatype;
-(void)ParseDataFinishedDownloading;
@end

@protocol LocalDBReadyForUseDelegate<NSObject>
-(void)databaseReadyForUse;
@end