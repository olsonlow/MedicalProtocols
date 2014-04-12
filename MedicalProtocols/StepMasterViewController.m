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
#import "DetailViewManager.h"

@interface StepMasterViewController ()

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
//    
//    DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
//    self.detailViewController = [[ProtocolDetailViewController alloc] init];
//    self.detailViewController.protocol = self.protocolData;
//    detailViewManager.detailViewController = self.detailViewController;
    
    [self.detailViewController performSegueWithIdentifier:@"FirstDetailViewToProtocolDetailView" sender:self];
    
    self.detailViewController = (StepDetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];
    //[self.detailViewController displayProgressHudWithMessage:@"Preparing Database"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
//    NSString* uuid = [ObjectUUID getUUID];
//    NSLog(@"UUID test = %@",uuid);
    
    NSString *num = [NSString stringWithFormat:@"Step %d",step.stepNumber];
    cell.textLabel.text = num;
    
    return cell;
}


//INCOMPLETE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        ProtocolStep *step = [self.protocolData stepAtIndex:indexPath.row];
       
        //self.detailViewController.step = step;//this line causes a break
        //[self.detailViewController performSegueWithIdentifier: @"MasterViewStepToComponent" sender:self];
    }
}

//INCOMPLELTE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     if([[segue identifier] isEqualToString:@"MasterViewStepToComponent"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ProtocolStep *step = [self.protocolData stepAtIndex:indexPath.row];
         //from here, move to a new view with a step's components
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
