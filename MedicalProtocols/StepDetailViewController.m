//
//  StepsDetailViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 11/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "StepDetailViewController.h"
#import "ProtocolStep.h"
#import "MedProtocol.h"
#import "Component.h"
#import "LocalDB.h"
#import "ComponentView.h"
#import <QuartzCore/QuartzCore.h>
@interface StepDetailViewController ()
- (void) configureView;
@property (assign, nonatomic) bool showProgressHud;
@property (copy, nonatomic) NSString* progressHudLabel;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation StepDetailViewController

#pragma mark - Managing the detail item

-(void)setProtocol:(MedProtocol *)protocol{
    if (_protocol != protocol) {
        _protocol = protocol;
        
        // Update the view.
        [self configureView];
    }
}

-(void)setStep:(ProtocolStep *)step
{
    if(_step != step)
    {
        _step = step;
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    // TODO updateView Based on protocol
    if(self.protocol && self.step)
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray * components = [[LocalDB sharedInstance]getAllObjectsWithDataType:DataTypeComponent withParentId:self.step.objectId];
    
    for(int i = 0; i < [components count]; i++)
    {
        id component = [components objectAtIndex:i];
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = YES;
        ComponentView *componentView = [[ComponentView alloc]initWithFrame:CGRectMake(100, 50, 50, 50)];
        componentView = [componentView initWithFrame:CGRectMake(100, 50, 50, 50) Object:component];
        [self.view addSubview:componentView];
    }
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
