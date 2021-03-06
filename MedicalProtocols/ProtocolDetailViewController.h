//
//  ProtocolDetailViewController.h
//  MedicalProtocols
//
//  Created by Luke Vergos, Zach Dahlgren, and Lowell Olson on 27/03/14.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//
#import "MedRefBaseDetailViewController.h"
#import "Component.h"

@class MedProtocol;
@class ProtocolStep;
@interface ProtocolDetailViewController : MedRefBaseDetailViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) MedProtocol* protocol;
@property (strong, nonatomic) ProtocolStep* step;
-(void)deleteCellAtindex:(int)index;
-(void)insertComponentOfComponentType:(ComponentType)componentType IntoCollectionViewAtLocation:(CGPoint)location;
@end
