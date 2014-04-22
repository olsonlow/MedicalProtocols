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
#import "MedProtocol.h"


@interface DataSource()
@property(nonatomic,strong) NSDate* lastUpdated;
@property(nonatomic,assign,readwrite) bool dataSourceReady;
-(id<MedRefDataSource>)getDataSource;
-(void)getParseUpdates;
-(void)readyForUse;
@end

@implementation DataSource
+(DataSource *) sharedInstance{
    return [DataSource sharedInstanceWithDelegate:nil];
}
+(DataSource *) sharedInstanceWithDelegate:(id<MedRefDataSourceDelegate>)delegate;
{
    static DataSource* sharedObject = nil;
    if(sharedObject == nil){
        sharedObject = [[DataSource alloc] init];
        sharedObject.medRefDataSourceDelegate = delegate;
    }
    return sharedObject;
}
-(id<MedRefDataSource>)getDataSource{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"dbinitialized"]){
        //initialise DB
        [LocalDB sharedInstanceWithDelegate:self];
        [[ParseDataSource sharedInstanceWithDelegate:self] downloadAllTablesFromParse];
    } else {
        NSCalendar *calender = [NSCalendar currentCalendar];
        NSDateComponents *dateComparison = [calender components:NSDayCalendarUnit fromDate:[defaults objectForKey:@"dbLastUpdated"]toDate:[NSDate date]options:0];
        
        NSLog(@"%ld,%d",((long)[dateComparison day]),[dateComparison day] > 1);
        if([dateComparison day] > 1) {
            [self getParseUpdates];
        } else {
            self.dataSourceReady = true;
        }
    }
    
    //UNCOMMENT THE CODE BELOW TO TEST ON-BOARD DB
    //MedProtocol *mp = [[MedProtocol alloc]initWithName:@"High Blood Pressure" objectId:1];
    //mp.name = @"High Blood Pressure";
    //[[LocalDB sharedInstance] updateObjectWithDataType:DataTypeProtocol withId:0 withObject:mp];
    //MedProtocol *newP = [[MedProtocol alloc]initWithName:@"Myocarditis" objectId:1];
    //[lb deleteObjectWithDataType:DataTypeProtocol withId:mp.objectId];
    //[[LocalDB sharedInstance] insertObjectWithDataType:DataTypeProtocol withObject:newP];
    return [LocalDB sharedInstance];
}
-(void)getParseUpdates{
    //TODO Compmplete parse updates
    self.dataSourceReady = true;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"dbLastUpdated"];
    [defaults synchronize];
    [self.medRefDataSourceDelegate dataSourceReadyForUse];
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType];
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(NSString*)parentId{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType withParentId:parentId];
}
-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)objectId withObject:(id)object{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource updateObjectWithDataType:dataType withId:objectId withObject:object];
}
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)objectId isChild:(bool)isChild{
    id<MedRefDataSource> dataSource = [self getDataSource];
    [[ParseDataSource sharedInstance]deleteObjectWithDataType:dataType withId:objectId isChild:isChild];
    return dataSource;
}
-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource insertObjectWithDataType:dataType withObject:object];
}
-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)objectId{
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"dbLastUpdated"];
    [defaults synchronize];
    [self readyForUse];
}
-(void)databaseReadyForUse{
    [self readyForUse];
}
-(void)readyForUse{
    if([LocalDB sharedInstance].dataSourceReady && [ParseDataSource sharedInstance].dataSourceReady){
        self.dataSourceReady = true;
        [self.medRefDataSourceDelegate dataSourceReadyForUse];
    }
}
@end
