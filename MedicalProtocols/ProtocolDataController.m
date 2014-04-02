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
#import "LocalDB.h"

@interface ProtocolDataController()
@property(nonatomic,strong) NSMutableArray* protocols;

@end

@implementation ProtocolDataController
- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"CREATING LOCALDB");
        LocalDB *pDB;
        [pDB createDB];
        _protocols = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];

        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseProtocol in results) {
                [_protocols addObject:[[MedProtocol alloc] initWithParseObject:parseProtocol]];
            }
        }];
        
        //set up in-app database (medRef.db)
        self.databaseName = @"medRef.db";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
        [self createAndCheckDatabase];
        
//        PFObject *textBlockObject = [PFObject objectWithClassName:@"TextBlock"];
//        textBlockObject[@"title"] = @"AFIB Anticoagulation";
//        textBlockObject[@"printable"] = [NSNumber numberWithBool:NO];
//        [textBlockObject save];
//        
//        PFObject *protocol = [PFObject objectWithClassName:@"Protocol"];
//        protocol[@"name"] = @"Atrial Fibrillation";
//        [protocol saveInBackground];
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
//        selectionComponent2[@"defaultValue"] = [NSNumber numberWithInt:0];
//        selectionComponent2[@"minValue"] = [NSNumber numberWithInt:0];
//        selectionComponent2[@"maxValue"] = [NSNumber numberWithInt:100];
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
//        
//        PFRelation *relation = [stepObject relationforKey:@"components"];
//        [relation addObject:textBlockObject];
//
//
//        stepObject[@"Components"] = [NSArray arrayWithObjects:textBlockObject, calculatorComponent, formComponent, linkObject, nil];
//        
//        protocol[@"steps"] = [NSArray arrayWithObjects:stepObject,nil];
//        [protocol saveInBackground];

    
        //TODO update parse backend by re-running below code
        
//        PFObject *protocol = [PFObject objectWithClassName:@"Protocol"];
//        protocol[@"name"] = @"Atrial Fibrillation";
//        [protocol saveInBackground];
//        
////        PFObject *component= [PFObject objectWithClassName:@"Component"];
////        component[@"color"] = @"0, 214, 132";
//        PFObject *stepObject = [PFObject objectWithClassName:@"Step"];
//        stepObject[@"stepNumber"] = [NSNumber numberWithInt:1];
//        stepObject[@"description"] = @"Decision Regarding Anticoagulation:";
//        stepObject[@"protocol"] = protocol;
//        [stepObject saveInBackground];
//        
//        PFObject *textBlockObject = [PFObject objectWithClassName:@"TextBlock"];
//        textBlockObject[@"title"] = @"AFIB Anticoagulation";
//        textBlockObject[@"printable"] = [NSNumber numberWithBool:NO];
//        textBlockObject[@"step"] = stepObject;
//        [textBlockObject saveInBackground];
//        
//        PFObject *calculatorComponent = [PFObject objectWithClassName:@"Calculator"];
//        calculatorComponent[@"step"] = stepObject;
//        [calculatorComponent saveInBackground];
//
//        PFObject *formComponent = [PFObject objectWithClassName:@"Form"];
//        PFObject *formNumberComponent = [PFObject objectWithClassName:@"FormNumber"];
//        formNumberComponent[@"label"] = @"Age";
//        formNumberComponent[@"defaultValue"] = [NSNumber numberWithInt:0];
//        formComponent[@"step"] = stepObject;
//        [formComponent saveInBackground];
//
//        PFObject *selectionComponent = [PFObject objectWithClassName:@"FormSelection"];
//        selectionComponent[@"label"] = @"Gender";
//        selectionComponent[@"choiceA"] = @"M";
//        selectionComponent[@"choiceB"] = @"F";
//        selectionComponent[@"form"] = formComponent;
//        [selectionComponent saveInBackground];
//
//        PFObject *selectionComponent2 = [PFObject objectWithClassName:@"FormNumber"];
//        selectionComponent2[@"label"] = @"EF(%)";
//        selectionComponent2[@"defaultValue"] = [NSNumber numberWithInt:0];
//        selectionComponent2[@"form"] = formComponent;
//        [selectionComponent2 saveInBackground];
//
//        PFObject *selectionComponent3 = [PFObject objectWithClassName:@"FormSelection"];
//        selectionComponent3[@"label"] = @"PM";
//        selectionComponent3[@"choiceA"] = @"Y";
//        selectionComponent3[@"choiceB"] = @"N";
//        selectionComponent3[@"form"] = formComponent;
//        [selectionComponent3 saveInBackground];
//        
//        PFObject *linkObject = [PFObject objectWithClassName:@"Link"];
//        linkObject[@"label"] = @"Calculator link";
//        linkObject[@"URL"] = @"http://www.mdcalc.com/chads2-score-for-atrial-fibrillation-stroke-risk/";
//        linkObject[@"step"] = stepObject;
//        [linkObject saveInBackground];
    }
    return self;
}

-(void) createAndCheckDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
        return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
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
