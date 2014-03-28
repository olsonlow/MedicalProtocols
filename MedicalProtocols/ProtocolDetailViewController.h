//
//  ProtocolDetailViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import <UIKit/UIKit.h>

@class Protocol;
@interface ProtocolDetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (strong, nonatomic) Protocol* protocol;

@end
