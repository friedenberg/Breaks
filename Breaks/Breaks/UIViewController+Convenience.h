//
//  UIViewController+Convenience.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/22/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Convenience)

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated wrapInNavigationController:(BOOL)wrap;

@end
