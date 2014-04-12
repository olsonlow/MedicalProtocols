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
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.showProgressHud){
        [self displayProgressHudWithMessage:self.progressHudLabel];
    } else {
        [self cancelProgressHud];
    }
    [self showProgressHud];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

@end
