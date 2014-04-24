//
//  FormAlgorithm.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/23/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormAlgorithm.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"
@interface FormAlgorithm : NSObject
@property (nonatomic, copy) NSString* objectId;
@property (nonatomic, copy) NSString* formId;
@property (nonatomic) int algOutput;
@property (nonatomic, copy) NSString* resultOne; //we really should have an array of potential results
@property (nonatomic, copy) NSString* resultTwo;
-(id) initWithFormId:(NSString*)formId algOutput:(int)algOutput resultOne:(NSString*)resultOne resultTwo:(NSString*)resultTwo;
-(int) computeAlgorithmOnInputs:(NSMutableArray*)formComponentInputs withAlgorithm:(NSString*)algorithm;
@end
