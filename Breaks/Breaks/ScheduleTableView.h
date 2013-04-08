//
//  ScheduleTableView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ScheduleBackgroundView, ScheduleRulerView, ScheduleViewShiftCell;

@interface ScheduleTableView : UITableView
{
	ScheduleBackgroundView *backgroundView;
	ScheduleRulerView *rulerView;
	
	//Geometry
    CGFloat hourWidth;
    NSRange hoursVisibleRange;
    CGFloat employeeHeaderWidth;
}

@property (nonatomic) CGFloat hourWidth;
@property (nonatomic) NSRange hoursVisibleRange;
@property (nonatomic) CGFloat employeeHeaderWidth;

@end
