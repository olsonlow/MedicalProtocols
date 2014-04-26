//
//  ProtocolMasterViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import <Parse/Parse.h>
#import "ProtocolMasterViewController.h"
#import "ProtocolDetailViewController.h"
#import "ProtocolDataController.h"
#import "MedProtocol.h"
#import "StepMasterViewController.h"

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
    self.editable = NO;
    
    //Navigation Button Items removed
    UINavigationController* navigationController = [self.splitViewController.viewControllers lastObject];
    self.detailViewController = (ProtocolDetailViewController *)[navigationController.viewControllers lastObject];
    self.protocolDataController = [[ProtocolDataController alloc] initWithDelegate:self];
    if(!self.protocolDataController.dataSourceReady){
        [self.detailViewController displayProgressHudWithMessage:@"Preparing Database"];
    }
}
-(void)setEditable:(BOOL)editable{
    super.editable = editable;
    if(editable){
        self.navigationItem.rightBarButtonItems = @[self.editButtonItem,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)]];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [self.protocolDataController createNewProtocol];
    [self.tableView reloadData];
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
    return self.editable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.protocolDataController removeProtocolAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {

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
    }
}
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {

    }
    [super viewWillDisappear:animated];
}
-(void)dataSourceReadyForUse{
    [NSThread sleepForTimeInterval:0.0001];
    NSLog(@"%@:%d",[self.protocolDataController protocolAtIndex:0].name,[self.protocolDataController countProtocols]);
    [self.detailViewController cancelProgressHud];
    [self.tableView reloadData];
}

@end
