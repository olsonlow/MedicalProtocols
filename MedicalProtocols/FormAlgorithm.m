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
    NSMutableArray *variables = [[NSMutableArray alloc]init];
    NSMutableArray *operators = [[NSMutableArray alloc]init];
   
    if([algSymbols count] != [algorithm length])
    {
        NSLog(@"ERROR: SOMETHING WENT WRONG");
    }
    
    //parse the algorithm to get all symbols
    for(int i = 0; i < [algSymbols count]; i++)
    {
        if([[algSymbols objectAtIndex:i] rangeOfString:@"v"].location !=NSNotFound)
        {
            //this symbol is a variable.
            NSLog(@"VAR SYMBOL: %@", [algSymbols objectAtIndex:i]);
            [variables addObject:[algSymbols objectAtIndex:i]];
        }
        else if([[algSymbols objectAtIndex:i]rangeOfString:@"||"].location != NSNotFound || [[algSymbols objectAtIndex:i]rangeOfString:@"&&"].location != NSNotFound || [[algSymbols objectAtIndex:i]rangeOfString:@"+"].location !=NSNotFound || [[algSymbols objectAtIndex:i]rangeOfString:@"-"].location !=NSNotFound || [[algSymbols objectAtIndex:i]rangeOfString:@"*"].location !=NSNotFound || [[algSymbols objectAtIndex:i]rangeOfString:@"/"].location !=NSNotFound)
        {
            //this symbol is an operator
            NSLog(@"OP SYMBOL: %@", [algSymbols objectAtIndex:i]);
            [operators addObject:[algSymbols objectAtIndex:i]];
        }
    
    }
    
    //error checking
    if([operators count] >= [variables count]) //if we have more operators than variables
    {
        NSLog(@"ERROR: INVALID ALGORITHM. %d operators to %d variables", [operators count], [variables count]);
        return -1;
    }
    
    if([formComponentInputs count] != [variables count])
    {
        NSLog(@"ERROR: INVALID INPUTS. %d var inputs to %d in alg", [formComponentInputs count], [variables count]);
        return -1;
    }
    //if we get here, everything is going well, proceed to compute algorithm
    int result = [[formComponentInputs objectAtIndex:0]intValue];
    for(int i = 0; i < [variables count]-1; i++)
    {
        NSString *operator = [[NSString alloc]init];
        for(int j = i; j < i+1; j++)
        {
            operator = [operators objectAtIndex:j];
        }
       //if([[operators objectAtIndex:i]rangeOfString:@"||"].location != NSNotFound)
       //     result += [formComponentInputs objectAtIndex:i] || [formComponentInputs objectAtIndex:i+1];
       // else if([[operators objectAtIndex:i]rangeOfString:@"&&"].location != NSNotFound)
       //     result += [formComponentInputs objectAtIndex:i] && [formComponentInputs objectAtIndex:i+1];
         if([[operators objectAtIndex:i]rangeOfString:@"+"].location != NSNotFound)
           result +=  [[formComponentInputs objectAtIndex:i+1]intValue];
        else if([[operators objectAtIndex:i]rangeOfString:@"-"].location != NSNotFound)
            result -= [[formComponentInputs objectAtIndex:i+1]intValue];
        else if([[operators objectAtIndex:i]rangeOfString:@"*"].location != NSNotFound)
            result *= [[formComponentInputs objectAtIndex:i+1]intValue];
        else if([[operators objectAtIndex:i]rangeOfString:@"/"].location != NSNotFound)
        {
            if([[formComponentInputs objectAtIndex:i+1]intValue] != 0)
                result /= [[formComponentInputs objectAtIndex:i+1]intValue];
            else
                NSLog(@"ERROR: DIVIDE BY ZERO");
        }
    }
    NSLog(@"RESULT: %d", result);
    return result;
}
@end
