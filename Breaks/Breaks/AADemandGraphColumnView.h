//
//  AADemandGraphColumnView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/19/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAViewRecyclerDelegate.h"


@interface AADemandGraphColumnView : UIView <AAViewRecycling>
{
	UIView *controlPointView;
	UIView *backgroundView;
}

@property (nonatomic, readonly) UIView *controlPointView;

@end
