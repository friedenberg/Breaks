//
//  AABezierGraphView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/16/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAViewRecyclerDelegate.h"


@class AAGraphLayerView, ScheduleViewBackgroundView, AAViewRecycler;

@interface AADemandGraphView : UIScrollView <AAViewRecyclerDelegate>
{
	UIView *columnContentView;
	ScheduleViewBackgroundView *backgroundView;
	
	AAViewRecycler *columnViewRecycler;
	
	NSRange rangeOfHours;
	CGFloat hourWidth;
	CGFloat unitHeight;
	
	NSRange visibleRange;
	
	NSMutableDictionary *columnData;
}

@property (nonatomic) NSRange rangeOfHours;
@property (nonatomic) CGFloat hourWidth;
@property (nonatomic) CGFloat unitHeight;

@end
