//
//  ComponentView.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Component.h"
@interface ComponentView : UIView
@property int stepId;
@property NSString *componentType;
@property id component;
@property (nonatomic,strong) id dataObject;

-(id)initWithFrame:(CGRect)frame Object:(id) object;
-(id)initWithFrame:(CGRect)frame;
@end
