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

-(id)initWithName:(NSString*)name objectId:(int)objectId{
    self = [super init];
    if (self) {
        _name = name;
        _objectId = objectId;
    }
    return self;
}

-(NSMutableArray *)steps{
    if(_steps == nil){
        _steps = [[NSMutableArray alloc] init];
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:self.dbPath];
        if(success)
        {
            [db open];
            FMResultSet *results = [db executeQuery:@"SELECT * FROM step WHERE protocolID = ?", self.objectId];
            while([results next])
            {
                ProtocolStep *step = [[ProtocolStep alloc] init];
                step.stepNumber = [results intForColumn:@"stepNumber"];
                step.description = [results stringForColumn:@"description"];
                step.objectId = [results intForColumn:@"objectID"];
                step.protocolId = [results intForColumn:@"protocolID"];
                step.updatedAt = [results dateForColumn:@"updatedAt"];
                step.createdAt = [results dateForColumn:@"createdAt"];
                [_steps addObject:step];
            }
            if ([db hadError]) {
                NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            }
            
            [db close];
        }
    }
    return _steps;
}

-(int)countSteps{
    return [self.steps count];
}
-(ProtocolStep*)stepAtIndex:(int)index{
    return [self.steps objectAtIndex:index];
}

@end
