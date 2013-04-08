//
//  ScheduleViewCell.h
//  
//
//  Created by Sasha Friedenberg on 4/29/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAViewRecycler.h"


@class AABadgeView;

@interface ScheduleViewCell : UIView <AAViewRecycling>
{
	UIView *contentView;
	UIImageView *imageView;
	AABadgeView *badgeView;
	
	BOOL shouldShowSelectionControlDuringEditing;
}

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UIImageView *imageView;

- (void)layoutSubviewsAnimated:(BOOL)animated;

- (void)setHighlighted;

@property (nonatomic) BOOL shouldShowSelectionControlDuringEditing;


@end
