//
//  Form.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormComponent.h"
#import "Component.h"
@class PFObject;
@class PFObject;

@interface Form : Component
@property(nonatomic,copy) NSString* stepId;
@property(nonatomic,copy) NSString* objectId;
@property (nonatomic, copy) NSString* label;
@property (nonatomic) NSMutableArray* formComponentData;
@property(nonatomic,assign) int orderNumber;

-(id)initWithObjectId:(NSString*)objectId label:(NSString*)label stepId:(NSString*)stepId orderNumber:(int)orderNumber;
-(FormComponent *) formComponentAtIndex: (int) index;
-(int) countFormComonents;
-(NSString *)formEntryComplete;
-(NSMutableArray*)storeEnteredDataFromView:(NSValue*)dataValue;
@end
