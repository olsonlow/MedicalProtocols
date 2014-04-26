//
//  StepBuilderMasterViewController.m
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 15/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "StepBuilderMasterViewController.h"
#import "ProtocolDetailViewController.h"
#import "ProtocolStep.h"
#import "Component.h"
@interface StepBuilderMasterViewController ()
@property(nonatomic,strong) UILabel* draggingView;
@property(nonatomic,assign) ComponentType selectedComponent;
@end

@implementation StepBuilderMasterViewController

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
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        self.detailViewController.step = nil;
    }
    [super viewWillDisappear:animated];
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
    return ComponentTypeCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepBuilderCell" forIndexPath:indexPath];
    NSString *componentName = [Component NameForComponentType:indexPath.row];
    cell.textLabel.text = componentName;
    cell.tag = indexPath.row;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(panGesture:)];
    
    [cell addGestureRecognizer:panGestureRecognizer];
    
    return cell;
}
- (void)panGesture:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // create item to be dragged, in this example, just a simple UILabel
        UITableViewCell* cell = ((UITableViewCell*)sender.view);
        UIView *splitView = self.splitViewController.view;
        CGPoint point = [sender locationInView:splitView];
        CGSize size = [cell.textLabel.text sizeWithAttributes:@{NSFontAttributeName:
                                                                    cell.textLabel.font}];
        CGRect frame = CGRectMake(point.x - (size.width / 2.0), point.y - (size.height / 2.0), size.width, size.height);
        self.draggingView = [[UILabel alloc] initWithFrame:frame];
        [self.draggingView setText:cell.textLabel.text];
        [self.draggingView setBackgroundColor:[UIColor clearColor]];
        
        // now add the item to the view
        
        [splitView addSubview:self.draggingView];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        // we dragged it, so let's update the coordinates of the dragged view
        
        UIView *splitView = self.splitViewController.view;
        CGPoint point = [sender locationInView:splitView];
        self.draggingView.center = point;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        // dropped, so remove it from the view
        UITableViewCell* cell = ((UITableViewCell*)sender.view);
        [self.draggingView removeFromSuperview];
        CGPoint point = [sender locationInView:self.detailViewController.view];
        point = CGPointMake(point.x+self.detailViewController.collectionView.contentOffset.x, point.y+self.detailViewController.collectionView.contentOffset.y);
        
        if (CGRectContainsPoint(self.detailViewController.collectionView.bounds, point)){
            [self.detailViewController insertComponentOfComponentType:cell.tag IntoCollectionViewAtLocation:point];
        }
        else
        {
            //dropped outside of details view
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {

    }
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

@end
