//
//  StepMasterViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 2/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "StepMasterViewController.h"
#import "ProtocolDetailViewController.h"
#import "MedProtocol.h"
#import "ProtocolStep.h"
#import "ProtocolMasterViewController.h"
#import "ProtocolDataController.h"
#import "StepBuilderMasterViewController.h"

@interface StepMasterViewController (){
    bool editable;
}
@end

@implementation StepMasterViewController
- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    editable = NO;
    [self makeEditable];
    [self.detailViewController performSegueWithIdentifier:@"FirstDetailViewToProtocolDetailView" sender:self];
//
//    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
//    self.detailViewController = [[ProtocolDetailViewController alloc] init];
//    self.detailViewController.protocol = self.protocolData;
//    detailViewManager.detailViewController = self.detailViewController;
    self.title = self.protocolData.name;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)makeEditable{
    editable = YES;
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)]];
    [self.tableView reloadData];
}
- (void)insertNewObject:(id)sender
{
    [self.protocolData addNewStep];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.protocolData countSteps];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepCell" forIndexPath:indexPath];
    ProtocolStep *step = [self.protocolData stepAtIndex:indexPath.row];
    cell.textLabel.text = step.description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController.step = [self.protocolData stepAtIndex:indexPath.row];
    }
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"MasterViewStepToStepBuilder"]){
        return editable;
    }
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     if([[segue identifier] isEqualToString:@"MasterViewStepToStepBuilder"]){
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         ProtocolStep *step = [self.protocolData stepAtIndex:indexPath.row];
         StepBuilderMasterViewController* stepBuilderMasterViewController = ((StepBuilderMasterViewController*)[segue destinationViewController]);
         stepBuilderMasterViewController.step = step;
         stepBuilderMasterViewController.detailViewController = self.detailViewController;
     }
}

-(void)dataSourceReadyForUse{
    [self.detailViewController cancelProgressHud];
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.detailViewController.navigationController popViewControllerAnimated:NO];
    }
    [super viewWillDisappear:animated];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return editable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.protocolData removeStepAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
