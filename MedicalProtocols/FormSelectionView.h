//
//  FormSelectionView.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson, Zach Dahlgren, and Lowell Olson on 4/15/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "FormView.h"
#import "FormSelection.h"
#import "FormComponentView.h"
@interface FormSelectionView : FormComponentView
@property (nonatomic) FormSelection* formSelection;
-(id) initWithFrame:(CGRect)frame andFormSelection:(FormSelection *)formSelection;
@end
