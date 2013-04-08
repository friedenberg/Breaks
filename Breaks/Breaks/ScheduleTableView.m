//
//  ScheduleTableView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleTableView.h"

#import "ScheduleTableViewCell.h"
#import "ScheduleBackgroundView.h"
#import "ScheduleRulerView.h"


@interface ScheduleViewShiftCell (PrivateAdditions)

- (void)setEmployeeHeaderViewXContentOffset:(CGFloat)offset;

@end


@implementation ScheduleTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
        self.hourWidth = 100;
        self.hoursVisibleRange = NSMakeRange(7, 15);
		self.employeeHeaderWidth = 200;
		//self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
		backgroundView = [[ScheduleBackgroundView alloc] initWithTable:self];
        self.backgroundView = backgroundView;
		self.backgroundColor = [UIColor clearColor];
		
		self.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
		
		rulerView = [[ScheduleRulerView alloc] initWithTable:self];
		self.tableHeaderView = rulerView;
	}
	
	return self;
}

- (CGRect)bounds
{
	CGRect bounds = super.bounds;

	if (shouldFakeFrame) bounds.size.width = self.contentSize.width;
	
	return bounds;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	CGPoint contentOffset = self.contentOffset;
	
    CGSize contentSize = self.contentSize;
    contentSize.width = employeeHeaderWidth + hoursVisibleRange.length * hourWidth;
	contentSize.height = MAX(bounds.size.height, contentSize.height);
    self.contentSize = contentSize;
	
    CGRect backgroundFrame = CGRectZero;
    backgroundFrame.size = contentSize;
    backgroundView.frame = backgroundFrame;
	
	CGRect rulerFrame = rulerView.frame;
	rulerFrame.size.height = 20;
	rulerFrame.size.width = contentSize.width;
	rulerFrame.origin.y = MAX(-rulerFrame.size.height, contentOffset.y);
	rulerView.frame = rulerFrame;
    
	CGFloat offset = MAX(0, contentOffset.x);
	
    CGFloat width = self.contentSize.width;
	NSLog(@"visible: %i", self.visibleCells.count);
    for (ScheduleViewShiftCell *cell in self.visibleCells)
    {
        CGRect frame = cell.frame;
        frame.size.width = width;
        //cell.frame = frame;
		[cell setEmployeeHeaderViewXContentOffset:offset];
    }
}

- (NSArray *)visibleCells
{
	shouldFakeFrame = YES;
	NSArray *visibleCells = super.visibleCells;
	shouldFakeFrame = NO;
	return visibleCells;
}

@synthesize hourWidth, hoursVisibleRange, employeeHeaderWidth;

- (void)setHourWidth:(CGFloat)value;
{
    hourWidth = value;
    [self setNeedsLayout];
    [backgroundView setNeedsDisplay];
}

- (void)setHoursVisibleRange:(NSRange)value
{
    hoursVisibleRange = value;
    [self setNeedsLayout];
    [backgroundView setNeedsDisplay];
}

- (void)setEmployeeHeaderWidth:(CGFloat)value
{
    employeeHeaderWidth = value;
	[self setNeedsLayout];
	[backgroundView setNeedsDisplay];
}

- (void)dealloc
{
	[backgroundView release];
	[rulerView release];
	[super dealloc];
}

@end
