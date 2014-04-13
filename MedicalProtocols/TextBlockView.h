//
//  TextBlockView.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "TextBlock.h"
@interface TextBlockView : ComponentView
@property (strong, nonatomic) TextBlock *textBlock;
-(id) initWithFrame:(CGRect)frame textBlock:(TextBlock *) textBlock;
-(void) formatDisplay;
@end
