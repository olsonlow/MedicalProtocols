//
//  FormAlgorithm.m
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/23/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

//NOTE: algorithms should be in NSString* format and be of the form "v1,+,v2,||,v3,*,v4" etc... with all
//components comma separated

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

-(int) computeAlgorithmOnInputs:(NSMutableArray*)formComponentInputs withAlgorithm:(NSString*)algorithm
{
//this function needs a particular algorithm to run (in array form) and an array of results from associated form components to run the algoritm on (the NSMutableArray property formComponentData in Form). It will return an int which will determine what will be displayed to the screen
    NSArray *algSymbols = [algorithm componentsSeparatedByString:@","];
    NSMutableArray *vars = [[NSMutableArray alloc]init];
    NSMutableArray *logiOp = [[NSMutableArray alloc]init];
    NSMutableArray *mathOp = [[NSMutableArray alloc]init];
   
    //parse the algorithm to get all symbols
    for(int i = 0; i < [algorithm length]; i++)
    {
        if([[[algSymbols objectAtIndex:i ]stringValue] rangeOfString:@"v"].location !=NSNotFound)
        {
            //this symbol is a variable.
            [vars addObject:[algSymbols objectAtIndex:i]];
        }
        else if([[[algSymbols objectAtIndex:i]stringValue]rangeOfString:@"||"].location != NSNotFound || [[[algSymbols objectAtIndex:i]stringValue]rangeOfString:@"&&"].location != NSNotFound)
        {
            //this symbol is a logical operator
            [logiOp addObject:[algSymbols objectAtIndex:i]];
        }
        else if([[[algSymbols objectAtIndex:i]stringValue]rangeOfString:@"+"].location !=NSNotFound || [[[algSymbols objectAtIndex:i]stringValue]rangeOfString:@"-"].location !=NSNotFound || [[[algSymbols objectAtIndex:i]stringValue]rangeOfString:@"*"].location !=NSNotFound || [[[algSymbols objectAtIndex:i]stringValue]rangeOfString:@"/"].location !=NSNotFound)
        {
            //this symbol is a basic math operator
            [mathOp addObject:[algSymbols objectAtIndex:i]];
        }
    }
    
    //error checking
    if([logiOp count] + [mathOp count] >= [vars count]) //if we have more operators than variables
    {
        NSLog(@"ERROR: INVALID ALGORITHM");
        return -1;
    }
    
    if([formComponentInputs count] != [vars count])
    {
        NSLog(@"ERROR: INVALID INPUTS");
        return -1;
    }
    //if we get here, everything is going well, proceed to compute algorithm
    
    return 0;
}
@end
