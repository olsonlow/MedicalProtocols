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
-(id<MedRefDataSource>)getDataSource;
-(void)getParseUpdates;
-(void)readyForUse;
@end

@implementation DataSource
-(id)initWithDelegate:(id<MedRefDataSourceDelegate>)delegate{
    self = [super init];
    if (self) {
        _medRefDataSourceDelegate = delegate;
    }
    return self;
}
-(id<MedRefDataSource>)getDataSource{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"dbinitialized"]){
        //initialise DB
        [LocalDB sharedInstanceWithDelegate:self];
        [[ParseDataSource sharedInstanceWithDelegate:self] downloadAllTablesFromParse];
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
    //UNCOMMENT THE CODE BELOW TO TEST ON-BOARD DB
//    LocalDB *lb = [LocalDB sharedInstance];
//    MedProtocol *mp = [[MedProtocol alloc]init];
//    mp.name = @"High Blood Pressure";
//    mp.objectId = @"ldsjgbljgr";
//    NSDate *now = [[NSDate alloc]init];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
//    mp.updatedAt = [calendar dateFromComponents:components];
//    [lb deleteObjectWithDataType:DataTypeProtocol withId:mp.objectId];
//    [lb insertObjectWithDataType:DataTypeProtocol withObject:mp];
    
    return [LocalDB sharedInstance];
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType];
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(int)parentId{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType withParentId:parentId];
}
-(bool)updateObjectWithDataType:(DataType)dataType withId:(int)objectId withObject:(id)object{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource updateObjectWithDataType:dataType withId:objectId withObject:object];
}
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(int)objectId{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource deleteObjectWithDataType:dataType withId:objectId];
}
-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    id<MedRefDataSource> dataSource = [self getDataSource];
    return [dataSource insertObjectWithDataType:dataType withObject:object];
}
-(id)getObjectWithDataType:(DataType)dataType withId:(int)objectId{
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
        [self.medRefDataSourceDelegate dataSourceReadyForUse];
    }
}
@end
