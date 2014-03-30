//
//  ProtocolDataController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolDataController.h"
#import "MedProtocol.h"
#import <Parse/Parse.h>
@interface ProtocolDataController()
@property(nonatomic,strong) NSMutableArray* protocols;

@end

@implementation ProtocolDataController
- (id)init
{
    self = [super init];
    if (self) {
        PFObject *patientObject = [PFObject objectWithClassName:@"patientObject"];
        patientObject[@"LName"] = @"Johnson";
        patientObject[@"FName"] = @"Davie";
        patientObject[@"AddressLine1"] = @"2112 Boulder Creek Lane";
        patientObject[@"AddressLine2"] = @"Rohnert Park CA, 99922";
        [patientObject saveInBackground];
    }
    return self;
}
-(NSMutableArray *)protocols{
    if (_protocols == nil)
        _protocols = [[NSMutableArray alloc] init];
    return _protocols;
}

-(int)countProtocols{
    return [self.protocols count];
}
-(MedProtocol*)protocolAtIndex:(int)index{
    return [self.protocols objectAtIndex:index];
}
@end
