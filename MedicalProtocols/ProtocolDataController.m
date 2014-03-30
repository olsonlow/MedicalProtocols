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
        PFObject *component= [PFObject objectWithClassName:@"Component"];
        component[@"color"] = @"0, 214, 132";
        PFObject *calculatorComponent = [PFObject objectWithClassName:@"Calculator"];
        PFObject *formComponent = [PFObject objectWithClassName:@"Form"];
        PFObject *formNumberComponent = [PFObject objectWithClassName:@"FormNumber"];
        
        formComponent[@"fields"] =
        
        PFObject *linkObject = [PFObject objectWithClassName:@"Link"];
        linkObject[@"label"] = @"Calculator link";
        linkObject[@"URL"] = @"http://www.mdcalc.com/chads2-score-for-atrial-fibrillation-stroke-risk/";
        
        PFObject *stepObject = [PFObject objectWithClassName:@"Step"];
        stepObject[@"stepNumber"] = [NSNumber numberWithInt:1];
        stepObject[@"description"] = @"Decision Regarding Anticoagulation:";
        stepObject[@"Components"] = [NSArray arrayWithObjects:calculatorComponent, nil];
        [stepObject saveInBackground];
        
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
