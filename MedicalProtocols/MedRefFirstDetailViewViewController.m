//
//  MedRefFirstDetailViewViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 12/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "MedRefFirstDetailViewViewController.h"
#import "StepMasterViewController.h"
#import "ProtocolDetailViewController.h"
#import "LoginViewController.h"

@interface MedRefFirstDetailViewViewController ()

@end

@implementation MedRefFirstDetailViewViewController

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

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"FirstDetailViewToProtocolDetailView"]){
        ProtocolDetailViewController* protocolDetailViewController = ((ProtocolDetailViewController*)[segue destinationViewController]);
        StepMasterViewController* stepMasterViewController = ((StepMasterViewController*)sender);
        protocolDetailViewController.protocol = stepMasterViewController.protocolData;
        stepMasterViewController.detailViewController = protocolDetailViewController;
    }
}
- (IBAction)unwindToFirstDetailViewController:(UIStoryboardSegue *)sender {
    
}

@end
