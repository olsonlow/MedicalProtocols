//
//  DataSource.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "DataSource.h"
#import "LocalDB.h"
#import "ParseDataSource.h"

@interface DataSource()
@property(nonatomic,strong) NSDate* lastUpdated;
-(id<MedRefDataSource>)getDataSource;
-(void)populateLocalDbFromParse;
-(void)getParseUpdates;
-(void)readyForUse;
@end

@implementation DataSource
-(id<MedRefDataSource>)getDataSource{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"dbinitialized"]){
        //initialise DB
        [LocalDB sharedInstanceWithDelegate:self];
        [self populateLocalDbFromParse];
    } else {
        NSCalendar *calender = [NSCalendar currentCalendar];
        NSDateComponents *dateComparison = [calender components:NSHourCalendarUnit fromDate:[defaults objectForKey:@"dbLastUpdated"]];
        if([dateComparison day] > 1) {
            [self getParseUpdates];
        } else {
            self.dataSourceReady = true;
            [self.medRefDataSourceDelegate dataSourceReadyForUse];
        }
    }
    
    return [LocalDB sharedInstance];
}
-(void)populateLocalDbFromParse{
    //initialise Parse
    ParseDataSource* parseDataSource = [ParseDataSource sharedInstanceWithDelegate:self];
    [parseDataSource getAllObjectsWithDataType:DataTypeProtocol];
    [parseDataSource getAllObjectsWithDataType:DataTypeStep];
    [parseDataSource getAllObjectsWithDataType:DataTypeComponent];
    [parseDataSource getAllObjectsWithDataType:DataTypeFormComponent];
    
    //Luke work from here, put parse objects into local db.
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"dbinitialized"];
//    [defaults setObject:[NSDate date] forKey:@"dbLastUpdated"];
//    [defaults synchronize];
}
-(void)getParseUpdates{
    
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType];
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(NSString*)parentId{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType withParentId:parentId];
}
-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource updateObjectWithDataType:dataType withId:idString withObject:object];
}
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource deleteObjectWithDataType:dataType withId:idString];
}
-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource insertObjectWithDataType:dataType withObject:object];
}
-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}
-(void)dataSourceReadyForUse{
    [self.medRefDataSourceDelegate dataSourceReadyForUse];
}
-(void)downloadedParseObject:(id)parseObject withDataType:(DataType)datatype{
    [[LocalDB sharedInstance] insertObjectWithDataType:datatype withObject:parseObject];
}
-(void)downloadedParseObjects:(NSArray*)parseObjects withDataType:(DataType)datatype{
    [parseObjects enumerateObjectsUsingBlock:^(id parseObject,NSUInteger idx,BOOL *stop){
        [self downloadedParseObject:parseObject withDataType:datatype];
    }];
}

-(void)ParseDataFinishedDownloading{
    [self readyForUse];
}
-(void)databaseReadyForUse{
    [self readyForUse];
}
-(void)readyForUse{
    if([LocalDB sharedInstance].dataSourceReady && [ParseDataSource sharedInstance].dataSourceReady){
        [self.medRefDataSourceDelegate dataSourceReadyForUse];
    }
}
@end
