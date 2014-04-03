//
//  MedProtocol.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "MedProtocol.h"
#import <Parse/Parse.h>
#import "ProtocolStep.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface MedProtocol()
@property (nonatomic,strong) NSMutableArray* steps;
@property (nonatomic) ProtocolStep* step;

@end

@implementation MedProtocol
- (id)initWithName:(NSString*)name steps:(NSMutableArray*)steps
{
    self = [super init];
    if (self) {
        _name = name;
        _steps = steps;
    }
    return self;
}

-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _name = parseObject[@"name"];
        _image = parseObject[@"protocolImage"];
        _steps = [[NSMutableArray alloc] init];

        PFQuery *query = [PFQuery queryWithClassName:@"Step"];
        [query whereKey:@"protocol" equalTo:parseObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseStepObject in results) {
                [_steps addObject:[[ProtocolStep alloc] initWithParseObject:parseStepObject]];
            }
        }];
    }
    return self;
}

-(id)initStepsFromDBForProtocolID:(NSString*)objectID{
    NSString *dbPath = @"medRef.db";
    self.steps = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM step"];
    while([results next])
    {
        ProtocolStep *step = [[ProtocolStep alloc] init];
        step.stepNumber = [results intForColumn:@"stepNumber"];
        [self.step initComponentsFromDBForStepID:[results stringForColumn:@"objectID"]];
        [self.steps addObject:step];
    }
    [db close];
}


-(int)countSteps{
    return [self.steps count];
}
-(ProtocolStep*)stepAtIndex:(int)index{
    return [self.steps objectAtIndex:index];
}
@end
