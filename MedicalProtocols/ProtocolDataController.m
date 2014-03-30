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
//        PFObject *protocol = [PFObject objectWithClassName:@"Protocol"];
//        protocol[@"name"] = @"Atrial Fibrillation";
//        
////        PFObject *component= [PFObject objectWithClassName:@"Component"];
////        component[@"color"] = @"0, 214, 132";
//        
//        PFObject *textBlockObject = [PFObject objectWithClassName:@"TextBlock"];
//        textBlockObject[@"title"] = @"AFIB Anticoagulation";
//        textBlockObject[@"printable"] = [NSNumber numberWithBool:NO];
//        
//        PFObject *calculatorComponent = [PFObject objectWithClassName:@"Calculator"];
//        
//        PFObject *formComponent = [PFObject objectWithClassName:@"Form"];
//        PFObject *formNumberComponent = [PFObject objectWithClassName:@"FormNumber"];
//        formNumberComponent[@"label"] = @"Age";
//        formNumberComponent[@"defaultValue"] = [NSNumber numberWithInt:0];
//        PFObject *selectionComponent = [PFObject objectWithClassName:@"FormSelection"];
//        selectionComponent[@"label"] = @"Gender";
//        selectionComponent[@"choiceA"] = @"M";
//        selectionComponent[@"choiceB"] = @"F";
//        PFObject *selectionComponent2 = [PFObject objectWithClassName:@"FormNumber"];
//        selectionComponent2[@"label"] = @"EF(%)";
//        formNumberComponent2[@"defaultValue"] = [NSNumber numberWithInt:0];
//        PFObject *selectionComponent3 = [PFObject objectWithClassName:@"FormSelection"];
//        selectionComponent3[@"label"] = @"PM";
//        selectionComponent3[@"choiceA"] = @"Y";
//        selectionComponent3[@"choiceB"] = @"N";
//        formComponent[@"fields"] = [NSArray arrayWithObjects:formNumberComponent,selectionComponent,selectionComponent2,selectionComponent3, nil];
//        
//        PFObject *linkObject = [PFObject objectWithClassName:@"Link"];
//        linkObject[@"label"] = @"Calculator link";
//        linkObject[@"URL"] = @"http://www.mdcalc.com/chads2-score-for-atrial-fibrillation-stroke-risk/";
//        
//        PFObject *stepObject = [PFObject objectWithClassName:@"Step"];
//        stepObject[@"stepNumber"] = [NSNumber numberWithInt:1];
//        stepObject[@"description"] = @"Decision Regarding Anticoagulation:";
//        stepObject[@"Components"] = [NSArray arrayWithObjects:textBlockObject, calculatorComponent, formComponent, linkObject, nil];
//        [stepObject saveInBackground];
//        
//        protocol[@"steps"] = [NSArray arrayWithObjects:stepObject,stepObject,stepObject, nil];
        
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
