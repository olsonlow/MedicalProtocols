//
//  ParseDataSource.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 5/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ParseDataSource.h"
#import <Parse/Parse.h>
#import "MedProtocol.h"
//#import "ProtocolStep.h"
//#import "TextBlock.h"
//#import "Link.h"
//#import "Calculator.h"
//#import "Form.h"
//#import "FormNumber.h"
//#import "FormSelection.h"

@interface ParseDataSource()
-(NSMutableArray*)getAllFromParseClassNamed:(NSString*)className;

@end

@implementation ParseDataSource
+(ParseDataSource *)sharedInstance
{
    static ParseDataSource* sharedObject = nil;
    if(sharedObject == nil)
        sharedObject = [[ParseDataSource alloc] init];
    return sharedObject;
}
-(NSArray*)getAll:(DataType)dataType{
    
//    DataTypeProtocol,
//    DataTypeStep,
//    DataTypeComponent,
//    DataTypeFormComponent
    NSMutableArray* dataTypes = nil;

    switch (dataType) {
        case DataTypeProtocol:
            dataTypes = [self getAllFromParseClassNamed:@"Protocol"];
            break;
            
        default:
            break;
    }
    
//    switch (dataType) {
//        case DataTypeProtocol:
//            NSMutableArray* protocols = [[NSMutableArray alloc] init];
//            dataTypes
//            
//            
//            break;
//            
//        default:
//            break;
//    }
    
    return dataTypes;
}
-(NSArray*)getAll:(DataType)dataType withParentId:(NSString*)parentId{
    return NULL;
}
-(bool)updateDataType:(DataType)dataType withId:(NSString*)idString withObject:(id)object{
    return NULL;
}
-(bool)deleteDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}
-(bool)insertDataType:(DataType)dataType withObject:(id)object{
    return NULL;
}
-(bool)getObjectDataType:(DataType)dataType withId:(NSString*)idString{
    return NULL;
}
-(NSMutableArray*)getAllFromParseClassNamed:(NSString*)className{
//    NSMutableArray* protocols = [[NSMutableArray alloc] init];
//    PFQuery *query = [PFQuery queryWithClassName:@"Protocol"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %d sprotocols.", objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                //[_protocols addObject:[[MedProtocol alloc] initWithParseObject:object]];
//            }
//        }
//    }
    return NULL;
}

//                MedProtocol *mp = [[MedProtocol alloc]init];
//                mp.name =object[@"name"];
//                mp.idStr = object.objectId;
//                mp.createdAt = object.createdAt;
//                mp.updatedAt = object.updatedAt;
//                [protocols addObject:mp];
//                //[self insertProtocol:mp];
//                
//            }
//        } else {
//            //Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
@end
