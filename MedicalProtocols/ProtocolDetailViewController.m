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
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"smallComponentCell" forIndexPath:indexPath];
    Component *component = [self.step componentAtIndex:indexPath.row];
    NSLog(@"COMPONENT TYPE: %@", component.class);
    ComponentView *componentView = [[ComponentView alloc]initWithFrame:cell.frame Object:component];
    componentView.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
    [cell addSubview:componentView];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 200);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}
-(void)insertComponentOfComponentType:(DataType)componentType IntoCollectionViewAtLocation:(CGPoint)location{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if(indexPath){
        //insert at index path
        self.step addNewComponentWithDataType:DA
    } else {
        //insert at end
    }
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}
- (IBAction)unwindToProtocolDetailViewController:(UIStoryboardSegue *)sender {
}
@end
