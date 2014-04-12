//
//  LinkView.h
//  MedicalProtocols
//
//  Created by Zach Dahlgren on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "Link.h"
@interface LinkView : ComponentView
@property (strong, nonatomic) Link *link;
-(id) initWithLink:(Link*)link;
-(void) formatDisplay;
@end
