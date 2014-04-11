//
//  ProtocolDetailViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolDetailViewController.h"
#import "MedProtocol.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "ProtocolStep.h"
@interface ProtocolDetailViewController ()
@property (assign, nonatomic) bool showProgressHud;
@property (copy, nonatomic) NSString* progressHudLabel;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation ProtocolDetailViewController

#pragma mark - Managing the detail item

-(void)setProtocol:(MedProtocol *)protocol{
    if (_protocol != protocol) {
        _protocol = protocol;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    // TODO updateView Based on protocol
    if(self.protocol)
    {
        NSString *steps = @"";
        
        for(ProtocolStep* step in self.protocol.steps)
        {
            [steps stringByAppendingString:step.description];
            [steps stringByAppendingString:@", "];
        }
        NSString *nameLabel = @"Protocol Name: ";
        self.protocolID.text  = [NSString stringWithFormat:@"Protocol ID:%i",self.protocol.objectId];
        NSString *stepsLabel = @"Protocol Steps: ";
        self.protocolName.text= [nameLabel stringByAppendingString:self.protocol.name];
        self.protocolSteps.text = [stepsLabel stringByAppendingString:steps];
    }
    else
    {
        self.protocolName.text = @"";
        self.protocolID.text = @"";
        self.protocolSteps.text = @"";
        
    }
    [self.view addSubview:self.protocolName];
    [self.view addSubview:self.protocolID];
    [self.view addSubview:self.protocolSteps];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.showProgressHud){
        [self displayProgressHudWithMessage:self.progressHudLabel];
    } else {
        [self cancelProgressHud];
    }
    [self showProgressHud];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
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
