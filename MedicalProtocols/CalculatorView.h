//
//  CalculatorView.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "Calculator.h"
@interface CalculatorView : ComponentView
@property (strong, nonatomic) Calculator *calculator;
-(id) initWithCalculator:(Calculator *) calculator;
-(void) formatDisplay;
@end
