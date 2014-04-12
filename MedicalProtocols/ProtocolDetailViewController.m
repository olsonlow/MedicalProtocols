//
//  ProtocolDetailViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "ProtocolDetailViewController.h"
#import "MedProtocol.h"
#import "ProtocolStep.h"
@interface ProtocolDetailViewController ()
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
            steps = [steps stringByAppendingString:step.description];
            steps = [steps stringByAppendingString:@", "];
        }
        NSString *nameLabel = @"Protocol Name: ";
        self.protocolID.text  = [NSString stringWithFormat:@"Protocol ID:%@",self.protocol.objectId];
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

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}
@end
