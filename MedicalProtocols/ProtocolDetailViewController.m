//
//  ProtocolDetailViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolDetailViewController.h"
#import "MedProtocol.h"
@interface ProtocolDetailViewController ()
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
        
        for(int i = 0; i < [_protocol.steps count]; i++)
        {
            [steps stringByAppendingString:[_protocol.steps objectAtIndex:i]];
            [steps stringByAppendingString:@", "];
        }
        NSString *nameLabel = @"Protocol Name: ";
        NSString *idLabel = @"Protocol ID: ";
        NSString *stepsLabel = @"Protocol Steps: ";
        self.protocolName.text= [nameLabel stringByAppendingString:self.protocol.name];
        self.protocolID.text = [idLabel stringByAppendingString:self.protocol.objectId];
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

@end
