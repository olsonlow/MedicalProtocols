//
//  ProtocolStep.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 30/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolStep.h"
#import <Parse/Parse.h>
#import "Component.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "TextBlock.h"
#import "Calculator.h"
#import "Link.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"

@interface ProtocolStep()
@property (nonatomic,strong) NSMutableArray* components;

@end
@implementation ProtocolStep
-(id)initWithId:(NSString*)objectId stepNumber:(int)stepNumber description:(NSString*)description protocolId:(NSString*)protocolId{
    self = [super init];
    if (self) {
        _description = description;
        _stepNumber = stepNumber;
        _objectId = objectId;
        _protocolId = protocolId;
    }
    
    return self;
}

-(NSMutableArray*)components{
    if(_components == nil){
        _components = [[NSMutableArray alloc] init];
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:self.dbPath];
        NSArray *componentList = [NSArray arrayWithObjects: @"textblock", @"calculator", @"link", @"form",nil];

        if(success)
        {
            [db open];
            for(NSString* componentName in componentList){
                FMResultSet *results = [db executeQuery:@"Select * from ? where stepID = ?",componentName, self.objectId];
                while([results next])
                {
                    if ([componentName isEqualToString: @"textblock"]) {
                        TextBlock *textBlock = [[TextBlock alloc] initWithTitle:[results stringForColumn:@"title"] content:[results stringForColumn:@"content"]  printable:[results boolForColumn:@"printable"] objectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:textBlock];
                    }
                    else if([componentName isEqualToString:@"calculator"]){
                        Calculator *calculator = [[Calculator alloc] initWithObjectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:calculator];
                    }
                    else if([componentName isEqualToString:@"link"]){
                        Link *link = [[Link alloc] initWithLabel:[results stringForColumn:@"label"] url:[results stringForColumn:@"url"] objectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:link];
                    }else{
                        Form *form = [[Form alloc]initWithObjectId:[results stringForColumn:@"objectID"] stepId:[results stringForColumn:@"stepID"]];
                        [_components addObject:form];
                        
                    }
                }
                if ([db hadError]) {
                    NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
            }
            [db close];
        }
    }
    return _components;
}
@end
