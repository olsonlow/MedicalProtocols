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
-(id<medRefDataSource>)getDataSource;
-(void)populateLocalDbFromParse;
-(void)getParseUpdates;
@end

@implementation DataSource
-(id<medRefDataSource>)getDataSource{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"dbinitialized"]){
        [LocalDB sharedInstance];
        [self populateLocalDbFromParse];
    } else {
        NSCalendar *calender = [NSCalendar currentCalendar];
        NSDateComponents *dateComparison = [calender components:NSHourCalendarUnit fromDate:[defaults objectForKey:@"dbLastUpdated"]];
        if([dateComparison day] > 0) {
            [self getParseUpdates];
        }
    }
    
    return [LocalDB sharedInstance];
}
-(void)populateLocalDbFromParse{
    ParseDataSource* parseDataSource = [ParseDataSource sharedInstance];
    NSArray* protocols = [parseDataSource getAllObjectsWithDataType:DataTypeProtocol];
    
    //Luke work from here, put parse objects into local db.
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"dbinitialized"];
//    [defaults setObject:[NSDate date] forKey:@"dbLastUpdated"];
//    [defaults synchronize];
}
-(void)getParseUpdates{
    
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType{
    id<medRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType];
}
-(NSArray*)getAllObjectsWithDataType:(DataType)dataType withParentId:(NSString*)parentId{
    id<medRefDataSource> dataSource = [self getDataSource];
    return [dataSource getAllObjectsWithDataType:dataType withParentId:parentId];
}
-(bool)updateObjectWithDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    id<medRefDataSource> dataSource = [self getDataSource];
    return [dataSource updateObjectWithDataType:dataType withId:idString withObject:object];
}
-(bool)deleteObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    id<medRefDataSource> dataSource = [self getDataSource];
    return [dataSource deleteObjectWithDataType:dataType withId:idString];
}
-(bool)insertObjectWithDataType:(DataType)dataType withObject:(id)object{
    id<medRefDataSource> dataSource = [self getDataSource];
    return [dataSource insertObjectWithDataType:dataType withObject:object];
}
-(id)getObjectWithDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}
@end
