//
//  LinkView.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson, Zach Dahlgren, and Lowell Olson on 4/12/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ComponentView.h"
#import "Link.h"
@interface LinkView : ComponentView
@property (strong, nonatomic) Link *link;
-(id)initWithFrame:(CGRect)frame andLink:(Link *)link;
-(void)buttonPressed:(id)sender;
@end
