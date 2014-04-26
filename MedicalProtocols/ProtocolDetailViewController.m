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
#import "ComponentView.h"
#import "StepMasterViewController.h"
#import "LocalDB.h"
#import "ComponentModalViewController.h"
#import "ComponentCell.h"

@interface ProtocolDetailViewController (){
    int componentToDeleteIndex;
    bool editable;
}
@property(nonatomic,strong) Component* selectedComponent;
@property(nonatomic,strong) ComponentCell* wobblingComponent;
- (void)configureView;
@end

@implementation ProtocolDetailViewController

#pragma mark - Managing the detail item

-(void)setProtocol:(MedProtocol *)protocol{
    if (_protocol != protocol) {
        _protocol = protocol;
        _step = nil;
        // Update the view.
        [self configureView];
    }
}
-(void)setStep:(ProtocolStep *)step{
    if (_step != step) {
        _step = step;
        // Update the view.
        [self configureView];
    }
}
- (void)configureView
{
    // Update the user interface for the detail item.
    // TODO updateView Based on protocol
    self.collectionView.hidden = (self.step == nil);
    if(self.step){
        [self.collectionView reloadData];
    }
    else if(self.protocol)
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.wobblingComponent stopWobble];
    self.wobblingComponent = nil;

    if([PFUser currentUser]){
        editable = YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.step countComponents];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ComponentCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"smallComponentCell" forIndexPath:indexPath];
    cell.index = [indexPath row];
    cell.delegate = self;
    cell.wobbling = NO;
    Component *component = [self.step componentAtIndex:indexPath.row];
    NSLog(@"COMPONENT TYPE: %@", component.class);
    CGRect cellFrame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    ComponentView* componentView = [[ComponentView alloc] initWithFrame:cellFrame Object:component];
    cell.backgroundColor=[UIColor clearColor];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGestureRecognizer];
    [cell addSubview:componentView];
    return cell;
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress{
    if(editable){
        self.wobblingComponent = (ComponentCell*)longPress.view;
        [self.wobblingComponent startWobble];
    }
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(self.collectionView.frame.size.x/2, self.collectionView.frame.size.y/2);
//}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.wobblingComponent){
        self.selectedComponent = [self.step componentAtIndex:indexPath.row];
        if(editable){
            [self performSegueWithIdentifier:@"ModalView" sender:self];
        }
    } else {
        [self.wobblingComponent stopWobble];
        self.wobblingComponent = nil;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.wobblingComponent stopWobble];
    self.wobblingComponent = nil;
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}
-(void)insertComponentOfComponentType:(ComponentType)componentType IntoCollectionViewAtLocation:(CGPoint)location{
    [self.wobblingComponent stopWobble];
    self.wobblingComponent = nil;
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if(indexPath){
        //insert at index path
        [self.step addNewComponentWithComponentType:componentType atIndex:indexPath.row];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    } else {
        [self.step addNewComponentWithComponentType:componentType];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.step countComponents]-1 inSection:0]]];
    }
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ModalView"]){
        ComponentModalViewController* modalView = [segue destinationViewController];
        modalView.component = self.selectedComponent;
    }
}
- (IBAction)unwindToProtocolDetailViewController:(UIStoryboardSegue *)sender {
    if([sender.identifier isEqualToString:@"FormSheetUnwindCancel"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if([sender.identifier isEqualToString:@"FormSheetUnwindSave"]){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.collectionView reloadData];
    }
}
-(void)deleteCellAtindex:(int)index{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warning" message: @"Do you wish to permanently delete this component?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Delete",nil];
    componentToDeleteIndex = index;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.collectionView performBatchUpdates:^{
            NSArray *selectedItemsIndexPaths = @[[NSIndexPath indexPathForRow:componentToDeleteIndex inSection:0]];
            // Delete the items from the data source.
            [self.step removeComponentAtIndex:componentToDeleteIndex];
            // Now delete the items from the collection view.
            [self.collectionView deleteItemsAtIndexPaths:selectedItemsIndexPaths];
        } completion:^(BOOL finished){
            if(finished){
                [self.collectionView reloadData];
            }
        }];
    } else {
        NSIndexPath* path = [NSIndexPath indexPathForRow:componentToDeleteIndex inSection:0];
        ComponentCell* componentCell = (ComponentCell*)[self.collectionView cellForItemAtIndexPath: path];
        [componentCell stopWobble];
    }
}
-(void)logout{
    [super logout];
    if(self.step){
       self.step = nil;
        [((UINavigationController*)[self.splitViewController.viewControllers firstObject]) popViewControllerAnimated:YES];
    }
    
}
@end
