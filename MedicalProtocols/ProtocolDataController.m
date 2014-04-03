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
#import "FMDB.h"
#import "FMResultSet.h"
#import "FMDatabase.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ProtocolDataController()
@property(nonatomic,strong) NSMutableArray* protocols;
@property(nonatomic) MedProtocol* protocol;

@end

@implementation ProtocolDataController
- (id)init
{
    self = [super init];
    if (self) {
        _protocols = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];

        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseProtocolObject in results) {
                [_protocols addObject:[[MedProtocol alloc] initWithParseObject:parseProtocolObject]];
            }
        }];
        
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
//        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
//            for (PFObject* parseProtocol in results) {
//                [_protocols addObject:[[MedProtocol alloc] initWithParseObject:parseProtocol]];
//            }
//        }];
        
        //set up in-app database (medRef.db)
        self.databaseName = @"medRef.db";
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"Private Documents/MedProtocol"];
        path = [path stringByAppendingPathComponent:@"medRef.db"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:path];
        if(!success)
        {
            NSLog(@"COPYING DB FROM RESOURCES TO LIBRARY");
            NSString *npath = [[NSBundle mainBundle] bundlePath];
            NSString *finalPath = [npath stringByAppendingPathComponent:@"medRef.db"];
            self.databasePath = finalPath;
            [self createAndCheckDatabase];
        }
        
        else
        {
            self.databasePath = [path stringByAppendingPathComponent:self.databaseName];
            [self createAndCheckDatabase];
        }
        
        //load the database from self.protocols
        //NSLog(@"NUM. PROTOCOLS: %d", [self.protocols count]);
        for(int i = 0; i < [self.protocols count]; i++)
        {
            MedProtocol *mp = [self.protocols objectAtIndex:i];
            [self insertProtocol:mp];
        }
        
        //dummy test
        MedProtocol *mp = [[MedProtocol alloc] init];
        mp.idStr = @"obj49djec";
        mp.name = @"Myocarditis";
        NSDate *now = [[NSDate alloc]init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        mp.createdAt = [calendar dateFromComponents:components];
        mp.updatedAt = [calendar dateFromComponents:components];
        [self insertProtocol:mp];
        [self populateFromDatabase]; //test to see if we can query the table
        
    
        
        //PFObject *textBlockObject = [PFObject objectWithClassName:@"TextBlock"];
        //textBlockObject[@"title"] = @"AFIB Anticoagulation";
        //textBlockObject[@"printable"] = [NSNumber numberWithBool:NO];
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
    //NSLog(@"CREATE AND CHECK DATABASE");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:self.databasePath];
    if(success)
    {
        NSLog(@"FILE PATH: %@ EXISTS", self.databasePath);
        return;
    } else {
        [NSException raise:@"database not found" format:@"we might have to create it programmatically :( tell Luke"];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
    }
}

-(NSMutableArray *) getProtocols
{
    return  self.protocols;
}

-(BOOL) insertProtocol:(MedProtocol *) mp
{
   //NSLog(@"INSERT PROTOCOL");
    FMDatabase *db = [FMDatabase databaseWithPath: self.databasePath];
    [db open];
    BOOL success = [db executeUpdate:@"INSERT INTO protocol (objectID, createdAt, updatedAt, pName) VALUES (?,?,?,?);", mp.idStr ,mp.createdAt, mp.updatedAt, mp.name, nil];
    return success;
}

-(BOOL) updateProtocol: (MedProtocol *) mp
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE protocol SET pName = '%@', updatedAt = '%@' where id = %@",mp.name, mp.updatedAt,mp.idStr]];
    [db close];
    return success;
}

-(NSMutableArray *)protocols{
    if (_protocols == nil)
        _protocols = [[NSMutableArray alloc] init];
    return _protocols;
}

//Create a method that builds a protocol from the onboard database
-(void)populateFromDatabase
{
    self.protocols = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath]; //Lowell: I changed this line to use our property databasePath -Zach
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM protocol"];
    while([results next])
    {
        MedProtocol *protocol = [[MedProtocol alloc] init];
        protocol.name = [results stringForColumn:@"pName"];
        NSLog(@"PROTOCOL NAME: %@", protocol.name);
        //[protocol stepAtIndex:0];
        [protocol initdbPath:self.databasePath];
        self.protocol = [protocol initWithName:protocol.name steps:protocol.steps];
        [self.protocols addObject:protocol];
    }
    [db close];
}



-(int)countProtocols{
    return [self.protocols count];
}
-(MedProtocol*)protocolAtIndex:(int)index{
    return [self.protocols objectAtIndex:index];
}
@end
