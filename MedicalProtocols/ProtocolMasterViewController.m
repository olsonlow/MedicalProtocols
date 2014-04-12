//
//  ProtocolMasterViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import <Parse/Parse.h>
#import "ProtocolMasterViewController.h"
#import "ProtocolDetailViewController.h"
#import "ProtocolDataController.h"
#import "MedProtocol.h"
#import "StepMasterViewController.h"
#import "StepDetailViewController.h"

@interface ProtocolMasterViewController ()

@property (strong,nonatomic) ProtocolDataController* protocolDataController;

@end

@implementation ProtocolMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Navigation Button Items removed
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;

    self.detailViewController = (ProtocolDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.protocolDataController = [[ProtocolDataController alloc] initWithDelegate:self];
    if(!self.protocolDataController.dataSourceReady){
        [self.detailViewController displayProgressHudWithMessage:@"Preparing Database"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.protocolDataController countProtocols];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProtocolCell" forIndexPath:indexPath];
    
    MedProtocol *protocol = [self.protocolDataController protocolAtIndex:indexPath.row];
    cell.textLabel.text = protocol.name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        MedProtocol *protocol = [self.protocolDataController protocolAtIndex:indexPath.row];
        self.detailViewController.protocol = protocol;
        [self.detailViewController performSegueWithIdentifier:@"ProtocolDetailViewToStepDetailView" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MedProtocol *protocol = [self.protocolDataController protocolAtIndex:indexPath.row];
        ((ProtocolDetailViewController*)[segue destinationViewController]).protocol = protocol;
    } else if([[segue identifier] isEqualToString:@"MasterViewProtocolToStep"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MedProtocol *protocol = [self.protocolDataController protocolAtIndex:indexPath.row];
        StepMasterViewController* stepMasterViewController = ((StepMasterViewController*)[segue destinationViewController]);
        stepMasterViewController.protocolData = protocol;
        stepMasterViewController.detailViewController = self.detailViewController;
    } else if([[segue identifier] isEqualToString:@"ProtocolDetailViewToStepDetailView"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MedProtocol *protocol = [self.protocolDataController protocolAtIndex:indexPath.row];
        StepsDetailViewController* stepDetailViewController = ((StepsDetailViewController*)[segue destinationViewController]);
        stepDetailViewController.protocol = protocol;
    }
}
-(void)dataSourceReadyForUse{
    [self.detailViewController cancelProgressHud];
    [self.tableView reloadData];
}

@end
