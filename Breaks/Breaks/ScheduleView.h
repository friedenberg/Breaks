//
//  ScheduleTableView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAViewEditing.h"
#import "AAViewRecyclerDelegate.h"
#import "ScheduleViewDataSource.h"
#import "ScheduleViewDelegate.h"


@class ScheduleView, ScheduleViewBackgroundView, ScheduleViewZoningView, ScheduleViewHeaderView, ScheduleViewTimeheadView, AAShadowView;

@class AAViewRecycler;

@interface ScheduleView : UIScrollView <AAViewEditing, AAViewRecyclerDelegate>
{
	NSDate *referenceDate;
	
	//cache
	NSUInteger numberOfRows;
	NSMutableArray *shiftDurations;
	NSMutableArray *zoningDurations;
	NSMutableArray *breakDurations;
	
	IBOutlet id <ScheduleViewDataSource> dataSource;
	IBOutlet id <ScheduleViewDelegate> delegate;
	
	
	UIView *upperLeftFillView;
	
	UIView *headerContentView;
	UIView *zoningContentView;
	UIView *breakContentView;
	
	ScheduleViewBackgroundView *backgroundView;
	ScheduleViewBackgroundView *rulerView;
	UIImageView *timeheadView;
	
	
	CGFloat timeheadProgress;
	
	
	//Geometry
	CGFloat rulerHeight;
	CGFloat rowHeight;
    CGFloat hourWidth;
    NSRange hoursVisibleRange;
    CGFloat headerWidth;
	
	NSRange visibleRowsRange;
	AADuration visibleDuration;
	
	//Reuse
	NSSet *viewRecyclers;
	AAViewRecycler *zoningViewRecycler;
	AAViewRecycler *headerViewRecycler;
	AAViewRecycler *breakViewRecycler;
	
	
	//zoning colors
	NSMutableDictionary *zoningViewTintedImages;
	
	struct
	{
		unsigned int headerTitles:1;
		unsigned int hexColors:1;
		unsigned int headerAccessoryImages:1;
		unsigned int breakImages:1;
		
		unsigned int didSelectZoningView:1;
		unsigned int didSelectBreakView:1;
		
	} delegateResponseFlags;
}

@property (nonatomic, assign) IBOutlet id <ScheduleViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <ScheduleViewDelegate> delegate;

@property (nonatomic, copy) NSDate *referenceDate; //defaults to the start of the day when the view is initialized

//geometry
@property (nonatomic) CGFloat rulerHeight;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat hourWidth;
@property (nonatomic) NSRange hoursVisibleRange;
@property (nonatomic) CGFloat headerWidth;

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)index;
- (CGRect)rectForHeaderAtIndexPath:(NSIndexPath *)index;
- (CGRect)rectForZoningAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)rectForBreakAtIndexPath:(NSIndexPath *)indexPath;

//time
@property (nonatomic, readonly) AADuration visibleDuration;

//zoning colors
@property (nonatomic, assign) NSSet *zoningViewHexColors;

//timehead management
@property (nonatomic, retain) NSDate *timeheadDisplayDate;

//animation
- (void)setRulerHeight:(CGFloat)value animated:(BOOL)animated;
- (void)setBlockHeight:(CGFloat)value animated:(BOOL)animated;
- (void)setHourWidth:(CGFloat)value animated:(BOOL)animated;
- (void)setHeaderWidth:(CGFloat)value animated:(BOOL)animated;

- (void)layoutSubviewsAnimated:(BOOL)animated;

//scrolling
- (void)scrollToBreakAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (void)reloadSchedule;

//data mutation
- (void)reloadVisibleRows;
- (void)reloadBreakAtIndexPath:(NSIndexPath *)breakPath animated:(BOOL)animated;

@end
