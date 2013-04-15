//
//  UIViewController+Convenience.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/22/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "UIViewController+Convenience.h"

@implementation UIViewController (Convenience)

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated wrapInNavigationController:(BOOL)wrap
{
	if (wrap)
	{
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
		navController.modalPresentationStyle = modalViewController.modalPresentationStyle;
		navController.modalTransitionStyle = modalViewController.modalTransitionStyle;
		modalViewController = navController;
	}
	
	[self presentModalViewController:modalViewController animated:animated];
}

@end
