//
//  DetailViewControllerSegue.m
//  MedicalProtocols
//
//  Created by Luke Vergos on 12/04/2014.
//  Copyright (c) 2014 Luke Vergos. All rights reserved.
//

#import "DetailViewControllerSegue.h"

@implementation DetailViewControllerSegue
-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    UINavigationController *navigationController = sourceViewController.navigationController;
    // Pop to root view controller (not animated) before pushing
    [navigationController pushViewController:destinationController animated:NO];
}
@end
