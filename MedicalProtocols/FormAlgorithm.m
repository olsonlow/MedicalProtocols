//
//  FormAlgorithm.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/23/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import "FormAlgorithm.h"
#import "Form.h"
#import "FormNumber.h"
#import "FormSelection.h"
@implementation FormAlgorithm
-(id) initWithFormId:(NSString *)formId algOutput:(int)algOutput resultOne:(NSString *)resultOne resultTwo:(NSString *)resultTwo
{
    self = [super init];
    if(self)
    {
        _formId = formId;
        _algOutput = algOutput;
        _resultOne = resultOne;
        _resultTwo = resultTwo;
    }
    return self;
}

-(int) computeAlgorithmOnInputs:(NSMutableArray*)formComponentInputs withAlgorithm:(NSMutableArray*)algorithm
{
    //this function needs a particular algorithm to run (in array form) and an array of results from associated form components to run the algoritm on (the NSMutableArray property formComponentData in Form). It will return an int which will determine what will be displayed to the screen
    return 0;
}
@end
