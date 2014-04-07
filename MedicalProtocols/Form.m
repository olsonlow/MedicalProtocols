//
//  Form.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Form.h"
#import <Parse/Parse.h>
#import "FormNumber.h"
#import "FormSelection.h"
#import "LocalDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface Form()
@property(nonatomic,strong) NSMutableArray* fields;
@end

@implementation Form
-(id)initWithObjectId:(NSString*)objectId stepId:(NSString*)stepId{
    self = [super init];
    if (self) {
        _objectId = objectId;
        _stepId = stepId;
    }
    return self;
}
-(id)initWithParseObject:(PFObject*)parseObject{
    self = [super init];
    if (self) {
        _fields = [[NSMutableArray alloc] init];
        
        PFQuery* query = [PFQuery queryWithClassName:@"FormNumber"];
        [query whereKey:@"step" equalTo:parseObject];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseComponentObject in results) {
                [_fields addObject:[[FormNumber alloc] initWithParseObject:parseComponentObject]];
            }
        }];
        
        query = [PFQuery queryWithClassName:@"FormSelection"];
        [query whereKey:@"step" equalTo:parseObject];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            for (PFObject* parseComponentObject in results) {
                [_fields addObject:[[FormSelection alloc] initWithParseObject:parseComponentObject]];
            }
        }];
    }
    return self;
}
-(NSMutableArray *)fields{
    if(_fields == nil){
//        _fields = [[NSMutableArray alloc]init];
//        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        BOOL success = [fileManager fileExistsAtPath:self.dbPath];
//        NSArray *formComponents = [NSArray arrayWithObjects:@"formNumber", @"formSelection",nil];
//        
//        if(success)
//        {
//            for(NSString* formComponent in formComponents){
//                FMResultSet *formResults = [db executeQuery:@"Select * from ? where formID = ?",formComponent, self.formId];
//                while([formResults next]){
//                    if([formComponent isEqualToString:@"formNumber"]){
//                        FormNumber *formNumber = [[FormNumber alloc]init];
//                        formNumber.formNumberId = [formResults stringForColumn:@"objectID"];
//                        formNumber.defaultValue = [formResults intForColumn:@"defaultValue"];
//                        formNumber.minValue = [formResults intForColumn:@"minValue"];
//                        formNumber.maxValue = [formResults intForColumn:@"maxValue"];
//                        formNumber.label = [formResults stringForColumn:@"label"];
//                        formNumber.createdAt = [formResults dateForColumn:@"createdAt"];
//                        formNumber.updatedAt = [formResults dateForColumn:@"updatesAt"];
//                        formNumber.formId = [formResults stringForColumn:@"formID"];
//                        [_fields addObject:formNumber];
//                    }
//                    else if([formComponent isEqualToString:@"formSelection"]){
//                        FormSelection *formSelection = [[FormSelection alloc]init];
//                        formSelection.formSelectionId = [formResults stringForColumn:@"objectID"];
//                        formSelection.choiceA = [formResults stringForColumn:@"choiceA"];
//                        formSelection.choiceB = [formResults stringForColumn:@"choiceB"];
//                        formSelection.label = [formResults stringForColumn:@"label"];
//                        formSelection.createdAt = [formResults dateForColumn:@"createdAt"];
//                        formSelection.updatedAt = [formResults dateForColumn:@"updatesAt"];
//                        formSelection.formId = [formResults stringForColumn:@"formID"];
//                        [_fields addObject:formSelection];
//                    }
//                }
//            }
//        }
    }
    return _fields;
}
@end
