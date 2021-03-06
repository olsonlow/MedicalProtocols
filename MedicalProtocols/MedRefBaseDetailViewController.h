//
//  MedRefBaseDetailViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 11/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MedRefBaseDetailViewController : UIViewController <UISplitViewControllerDelegate, PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (nonatomic,assign,readonly) BOOL loggedIn;
-(void)displayProgressHudWithMessage:(NSString*)message;
-(void)cancelProgressHud;
-(void)logout;
-(void)refreshView;
@end
