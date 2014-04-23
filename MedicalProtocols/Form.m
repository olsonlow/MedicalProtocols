//
//  Form.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"
#import "DataSource.h"
#import "FormComponent.h"

@interface Form()
@property(nonatomic,strong) NSMutableArray* fields;
@property(nonatomic,strong) NSMutableArray* formComponents;
@end

@implementation Form
- (instancetype)init
{
    return [self initWithObjectId:[[[NSUUID alloc] init] UUIDString] label:@"Form" stepId:@"" orderNumber:-1];
}
-(id)initWithObjectId:(NSString*)objectId label:(NSString*)label stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super initWithObjectId:objectId StepId:stepId OrderNumber:orderNumber];
    if (self) {
        _label = label;
    }
    return self;
}
-(NSMutableArray*)formComponents{
    if(_formComponents == nil){
        _formComponents = [[NSMutableArray alloc] init];
        [_formComponents addObjectsFromArray:[[DataSource sharedInstance]getAllObjectsWithDataType: DataTypeFormComponent withParentId:self.objectId]];
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderNumber" ascending:YES];
        [_formComponents sortUsingDescriptors:@[sortDescriptor]];
    }
    return _formComponents;
}

-(int) countFormComonents
{
    return [self.formComponents count];
}

-(FormComponent *) formComponentAtIndex: (int) index
{
    return [self.formComponents objectAtIndex:index];
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
