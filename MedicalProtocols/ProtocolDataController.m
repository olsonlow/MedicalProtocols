//
//  ProtocolDataController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolDataController.h"
#import "MedProtocol.h"
#import "DataSource.h"
#import <Parse/Parse.h>

@interface ProtocolDataController()
@property (readwrite,assign, nonatomic) bool dataSourceReady;
@property(nonatomic,strong) NSMutableArray* protocols;
@property (nonatomic, strong) DataSource<MedRefDataSource> *dataSource;
@property(nonatomic,assign) id<MedRefDataSourceDelegate> medRefDataSourceDelegate;

@end


@implementation ProtocolDataController
-(id)initWithDelegate:(id<MedRefDataSourceDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        _dataSourceReady = NO;
        _medRefDataSourceDelegate = delegate;
        _dataSource = [DataSource sharedInstanceWithDelegate:self];
        _protocols = [[NSMutableArray alloc] init];
        [_protocols addObjectsFromArray:[_dataSource getAllObjectsWithDataType:DataTypeProtocol]];
        _dataSourceReady = _dataSource.dataSourceReady;
    }
    return self;
}
-(int)countProtocols{
    return [self.protocols count];
}
-(void)removeProtocolAtIndex:(int)index{
    [self.dataSource deleteObjectWithDataType:DataTypeProtocol withId:((MedProtocol*)[self.protocols objectAtIndex:index]).objectId isChild:NO];
    [self.protocols removeObjectAtIndex:index];
}
-(MedProtocol*)protocolAtIndex:(int)index{
    return [self.protocols objectAtIndex:index];
}
-(void)createNewProtocol{
    MedProtocol* newProtocol = [[MedProtocol alloc] initWithName:@"New Protocol" objectId:[[[NSUUID alloc] init] UUIDString]];
    [self.dataSource insertObjectWithDataType:DataTypeProtocol withObject:newProtocol];
    [self.protocols addObject:newProtocol];
}
-(void)dataSourceReadyForUse{
    //[self.protocols addObjectsFromArray:[self.dataSource getAllObjectsWithDataType:DataTypeProtocol]];
    _dataSourceReady = YES;
    [self.protocols addObjectsFromArray:[_dataSource getAllObjectsWithDataType:DataTypeProtocol]];
    [self.medRefDataSourceDelegate dataSourceReadyForUse];
}
@end
