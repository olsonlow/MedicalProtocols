//
//  ProtocolDataController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolDataController.h"
@interface ProtocolDataController()
@property(nonatomic,strong) NSMutableArray* protocols;

@end

@implementation ProtocolDataController
-(NSMutableArray *)protocols{
    if (_protocols == nil)
        _protocols = [[NSMutableArray alloc] init];
    return _protocols;
}

-(int)countProtocols{
    return [self.protocols count];
}
-(Protocol*)protocolAtIndex:(int)index{
    return [self.protocols objectAtIndex:index];
}
@end
