//
//  MedRefBaseDetailViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 11/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "MedRefBaseDetailViewController.h"
#import "DetailViewControllerSegue.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "LoginViewController.h"
#import "BaseMasterTableViewController.h"

@interface MedRefBaseDetailViewController ()
@property (assign, nonatomic) bool showProgressHud;
@property (copy, nonatomic) NSString* progressHudLabel;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation MedRefBaseDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.hidesBackButton = YES;
    [self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    //TODO
    //swipe.numberOfTouchesRequired = 5; //uncomment for testing on Ipad.
    [self.view addGestureRecognizer:swipe];
    
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self refreshView];
    
}
-(void)refreshView{
    if(self.showProgressHud){
        [self displayProgressHudWithMessage:self.progressHudLabel];
    } else {
        [self cancelProgressHud];
    }
    [self showProgressHud];
    
    if([PFUser currentUser]){
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)]];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    DetailViewControllerSegue *segue = [[DetailViewControllerSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    return segue;
}

-(void)displayProgressHudWithMessage:(NSString*)message{
    self.showProgressHud = YES;
    self.progressHudLabel = message;
    if (self.isViewLoaded && self.view.window) {
        [SVProgressHUD showWithStatus:self.progressHudLabel];
        self.view.userInteractionEnabled = NO;
        
    }
}
-(void)cancelProgressHud{
    self.showProgressHud = NO;
    if (self.isViewLoaded && self.view.window) {
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        
    }
}
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        UINavigationController* navigationController = [self.splitViewController.viewControllers firstObject];
        ((BaseMasterTableViewController *)[navigationController.viewControllers lastObject]).editable = YES;
        
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)swipedRight:(id)sender {
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        LoginViewController *logInViewController = [[LoginViewController alloc] init];
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsDismissButton;
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}
-(void)logout{
    [PFUser logOut];
    [self refreshView];
    [((BaseMasterTableViewController*)[[[self.splitViewController.viewControllers firstObject] viewControllers] lastObject]) refreshView];
}

@end
