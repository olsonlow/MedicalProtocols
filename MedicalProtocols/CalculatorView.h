//
//  CalculatorView.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson, Zach Dahlgren, and Lowell Olson on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "Calculator.h"
@interface CalculatorView : ComponentView
@property (strong, nonatomic) Calculator *calculator;
-(id) initWithFrame:(CGRect)frame andCalculator:(Calculator *) calculator;
@end
