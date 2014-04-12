//
//  MedRefBaseDetailViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos on 11/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedRefBaseDetailViewController : UIViewController <UISplitViewControllerDelegate>
-(void)displayProgressHudWithMessage:(NSString*)message;
-(void)cancelProgressHud;
@end
