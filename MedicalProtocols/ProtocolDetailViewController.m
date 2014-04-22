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

@interface ProtocolDetailViewController ()

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
    ComponentView *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"smallComponentCell" forIndexPath:indexPath];
    Component *component = [self.step componentAtIndex:indexPath.row];
    NSLog(@"COMPONENT TYPE: %@", component.class);
    cell.dataObject = component;
    cell.backgroundColor=[UIColor clearColor];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGestureRecognizer];
    return cell;
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress{
    [(ComponentView*)longPress.view startWobble];
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(self.collectionView.frame.size.x/2, self.collectionView.frame.size.y/2);
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Component *component = [self.step componentAtIndex:indexPath.row];
    [self displayModalViewWithComponent:component];
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}
-(void)insertComponentOfComponentType:(ComponentType)componentType IntoCollectionViewAtLocation:(CGPoint)location{
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

}
- (IBAction)unwindToProtocolDetailViewController:(UIStoryboardSegue *)sender {
}
- (void)displayModalViewWithComponent:(Component*) component {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ComponentModalViewController *modalViewController = [storyboard instantiateViewControllerWithIdentifier:@"ModalView"];
    modalViewController.view.backgroundColor = [UIColor clearColor];
    modalViewController.component = component;
    modalViewController.delegate = self;
    modalViewController.modalPresentationStyle= UIModalPresentationCustom;
    [self presentViewController:modalViewController animated:YES completion:nil];
}
@end
