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
    if(self.step)
    {
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self configureView];
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
    Component* component = [self.step componentAtIndex:indexPath.row];
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"smallComponentCell" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(150, 150);
//}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}
@end
