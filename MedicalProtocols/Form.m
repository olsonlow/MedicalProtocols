//
//  Form.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 31/03/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"
#import "DataSource.h"
#import "FormComponent.h"
#import "FormAlgorithm.h"

@interface Form()
@property(nonatomic,strong) NSMutableArray* formComponents;
@end

@implementation Form
- (instancetype)init
{
    return [self initWithObjectId:[[[NSUUID alloc] init] UUIDString] label:@"Form" stepId:@"" orderNumber:-1];
}
-(id)initWithObjectId:(NSString*)objectId label:(NSString*)label stepId:(NSString*)stepId orderNumber:(int)orderNumber{
    self = [super initWithObjectId:objectId StepId:stepId OrderNumber:orderNumber componentType:ComponentTypeForm];
    if (self) {
        _label = label;
        _formComponentData = [[NSMutableArray alloc]init];
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
    NSString *result = self.formEntryComplete;
    NSLog(@"result: %@", result);
    return _formComponents;
}

-(NSString *)formEntryComplete
{
    NSString *alg = @"v1,+,v2,-,v3,*,v4,+,v5,/,v6";
    FormAlgorithm *fA = [[FormAlgorithm alloc]initWithFormId:self.objectId algOutput:0 resultOne:@"WOO" resultTwo:@"NOO"];
    NSArray *v = @[@17, @3, @45, @0,@15, @8];
    NSMutableArray *values = [[NSMutableArray alloc]initWithArray:v];
    [fA computeAlgorithmOnInputs:values withAlgorithm:alg];
    return fA.resultOne;
}

-(int) countFormComonents
{
    return [self.formComponents count];
}

-(FormComponent *) formComponentAtIndex: (int) index
{
    return [self.formComponents objectAtIndex:index];
}

-(NSMutableArray*)storeEnteredDataFromView:(NSValue*)dataValue
{
    //this function should take in data supplied by the user in the formComponent views and store them in an array that we can pass to formAlgorithm
    [self.formComponentData addObject:dataValue];
    return self.formComponentData;
}
-(int)numberOfEditableProperties{
    return 0;
}
@end
