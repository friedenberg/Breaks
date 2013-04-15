//
//  ScheduleTableView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleView.h"

#import "ScheduleViewZoningView.h"
#import "ScheduleViewHeaderView.h"
#import "ScheduleViewBackgroundView.h"
#import "ScheduleViewBreakView.h"

#import "AAObjectController.h"
#import "AAViewRecycler.h"

#import "UIColor-Expanded.h"

#import "NSDate+ScheduleViewDateAdditions.h"


@interface ScheduleView ()

- (void)layoutSubviewsForVisibleRect:(CGRect)visibleRect;
- (void)calculateContentInset;

- (void)reloadCache;
- (void)didReceiveMemoryWarning;

@end

@implementation ScheduleView

static UIImage *kTimeheadCarotImage;

+ (void)initialize
{
    if (self == [ScheduleView class]) {
        kTimeheadCarotImage = [[UIImage imageNamed:@"timeheadCarot"] resizableImageWithCapInsets:UIEdgeInsetsMake(31, 0, 0, 0)];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		self.referenceDate = [NSDate today];
		visibleRowsRange = NSMakeRange(0, 0);
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		
		self.rulerHeight = 40;
		self.rowHeight = 44;
        self.hourWidth = 100;
        self.hoursVisibleRange = NSMakeRange(7, 20);
		self.headerWidth = 200;
        
		visibleDuration = AADurationZero;
		
		shiftDurations = [NSMutableArray new];
		zoningDurations = [NSMutableArray new];
		breakDurations = [NSMutableArray new];
        
		
		backgroundView = [[ScheduleViewBackgroundView alloc] initWithFrame:CGRectZero];
		backgroundView.rulerHeight = self.rulerHeight;
		backgroundView.hoursVisibleRange = self.hoursVisibleRange;
        
		zoningContentView = [[UIView alloc] initWithFrame:CGRectZero];
		breakContentView = [[UIView alloc] initWithFrame:CGRectZero];
        
		rulerView = [[ScheduleViewBackgroundView alloc] initWithFrame:CGRectZero];
		rulerView.showsRuler = YES;
        rulerView.hoursVisibleRange = self.hoursVisibleRange;
        rulerView.rulerHeight = self.rulerHeight;
        
		timeheadView = [[UIImageView alloc] initWithImage:kTimeheadCarotImage];
		headerContentView = [[UIView alloc] initWithFrame:CGRectZero];
		upperLeftFillView = [[UIView alloc] initWithFrame:CGRectZero];
		upperLeftFillView.backgroundColor = [UIColor whiteColor];
		upperLeftFillView.clipsToBounds = YES;
		
		//layer order
		[self addSubview:backgroundView];
		[self addSubview:zoningContentView];
		[self addSubview:breakContentView];
		[self addSubview:rulerView];
		[self addSubview:timeheadView];
		[self addSubview:headerContentView];
		[self addSubview:upperLeftFillView];
		
		
		//reuse controllers
		zoningViewRecycler = [[AAViewRecycler alloc] initWithDelegate:self];
		headerViewRecycler = [[AAViewRecycler alloc] initWithDelegate:self];
		breakViewRecycler = [[AAViewRecycler alloc] initWithDelegate:self];
		zoningViewRecycler.delegate = self;
		headerViewRecycler.delegate = self;
		breakViewRecycler.delegate = self;
		
		viewRecyclers = [[NSSet alloc] initWithObjects:headerViewRecycler, zoningViewRecycler, breakViewRecycler, nil];
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(didReceiveMemoryWarning) 
													 name:UIApplicationDidReceiveMemoryWarningNotification 
												   object:nil];
	
		
		zoningViewTintedImages = [NSMutableDictionary new];
		
		[self calculateContentInset];
		
		self.timeheadDisplayDate = [NSDate date];
	}
	
	return self;
}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	[self reloadSchedule];
}

#pragma mark - geometry convenience

static CGPoint CGPointFloor(CGPoint point)
{
	point.x = floor(point.x);
	point.y = floor(point.y);
	return point;
}

static CGSize CGSizeFloor(CGSize size)
{
	size.width = floor(size.width);
	size.height = floor(size.height);
	return size;
}

static CGRect CGRectFloor(CGRect rect)
{
	rect.origin = CGPointFloor(rect.origin);
	rect.size = CGSizeFloor(rect.size);
	return rect;
}

#pragma mark - convenience

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	CGRect frame = CGRectZero;
	frame.origin.y = (rowHeight * [indexPath indexAtPosition:1]);
	frame.size.width = self.contentSize.width;
	frame.size.height = rowHeight;
	
	return frame;
}

- (CGRect)rectForHeaderAtIndexPath:(NSIndexPath *)indexPath;
{
	CGRect frame = [self rectForRowAtIndexPath:indexPath];
	frame.size.width = headerWidth;
	
	return frame;
}
- (CGRect)rectForZoningAtIndexPath:(NSIndexPath *)indexPath
{
	AADuration duration;
	[[[zoningDurations objectAtIndex:[indexPath indexAtPosition:1]] objectAtIndex:[indexPath indexAtPosition:2]] getValue:&duration];
	
	CGRect frame = [self rectForRowAtIndexPath:indexPath];
	frame.origin.x = (duration.start - hoursVisibleRange.location) * hourWidth;
	frame.size.width = duration.length * hourWidth;
	frame.size.width = MIN(CGRectGetMaxX(frame), self.contentSize.width) - CGRectGetMinX(frame);
	//frame.size.height--;
	
	frame = CGRectFloor(frame);
	
	return frame;
}

- (CGRect)rectForBreakAtIndexPath:(NSIndexPath *)indexPath
{
	AADuration duration;
	[[[breakDurations objectAtIndex:[indexPath indexAtPosition:1]] objectAtIndex:[indexPath indexAtPosition:2]] getValue:&duration];
	
	CGRect frame = [self rectForRowAtIndexPath:indexPath];
	frame.origin.x += (duration.start - hoursVisibleRange.location) * hourWidth;
	frame.size.width = duration.length * hourWidth;
	
	frame = CGRectFloor(frame);
	
	return frame;
}

- (UIView *)superviewForViewWithKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler
{
	if (someViewRecycler == headerViewRecycler)
	{
		return headerContentView;
	}
	else if (someViewRecycler == zoningViewRecycler)
	{
		return zoningContentView;
	}
	else if (someViewRecycler == breakViewRecycler)
	{
		return breakContentView;
	}
	else @throw [NSException exceptionWithName:NSGenericException reason:@"Unknown view recycler passed into -unusedViewForViewRecycler" userInfo:nil];
}

- (UIView <AAViewRecycling> *)unusedViewForViewRecycler:(AAViewRecycler *)someViewRecycler
{
	if (someViewRecycler == headerViewRecycler)
	{
		return [[ScheduleViewHeaderView alloc] initWithFrame:CGRectZero];
	}
	else if (someViewRecycler == zoningViewRecycler)
	{
		return [[ScheduleViewZoningView alloc] initWithFrame:CGRectZero];
	}
	else if (someViewRecycler == breakViewRecycler)
	{
		return [[ScheduleViewBreakView alloc] initWithFrame:CGRectZero];
	}
	else @throw [NSException exceptionWithName:NSGenericException reason:@"Unknown view recycler passed into -unusedViewForViewRecycler" userInfo:nil];
}

- (BOOL)visibilityForKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler
{
	NSIndexPath *indexPath = key;
	
	BOOL isVisible = NSLocationInRange([key indexAtPosition:1], visibleRowsRange);
	
	if (someViewRecycler == zoningViewRecycler)
	{
		AADuration duration;
		[[[zoningDurations objectAtIndex:[indexPath indexAtPosition:1]] objectAtIndex:[indexPath indexAtPosition:2]] getValue:&duration];
		
		BOOL overlap = AADurationsOverlap(visibleDuration, duration);
		isVisible = overlap && isVisible;
	}
	else if (someViewRecycler == breakViewRecycler)
	{
		AADuration duration;
		[[[breakDurations objectAtIndex:[indexPath indexAtPosition:1]] objectAtIndex:[indexPath indexAtPosition:2]] getValue:&duration];
		
		BOOL overlap = AADurationsOverlap(visibleDuration, duration);
		isVisible = overlap && isVisible;
	}
	
	return isVisible;
}

- (CGRect)rectForViewWithKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler
{
	if (someViewRecycler == headerViewRecycler)
	{
		return [self rectForHeaderAtIndexPath:key];
	}
	else if (someViewRecycler == zoningViewRecycler)
	{
		return [self rectForZoningAtIndexPath:key];
	}
	else if (someViewRecycler == breakViewRecycler)
	{
		return [self rectForBreakAtIndexPath:key];
	}
	else @throw [NSException exceptionWithName:NSGenericException reason:@"Unknown view recycler passed into -rectForViewWithKey:viewRecycler" userInfo:nil];
}

//#define DIFFERENCE(a, b) ABS((a - b))
#define BETWEEN(lower, value, upper) MAX(lower, MIN(upper, value))

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	CGPoint contentOffset = self.contentOffset;
    CGRect visibleRect = bounds;
	visibleRect.origin = contentOffset;
	
	[self layoutSubviewsForVisibleRect:visibleRect];
}

- (void)layoutSubviewsForVisibleRect:(CGRect)visibleRect
{
	CGRect bounds = self.bounds;
    CGSize contentSize = self.contentSize;
	
	
	//scroller insets
	UIEdgeInsets insets = UIEdgeInsetsZero;
	insets.left = visibleRect.origin.x >= -headerWidth ? headerWidth : -visibleRect.origin.x;
	insets.top = rulerHeight;
	insets.right = MAX(CGRectGetMaxX(visibleRect) - contentSize.width, 0);
	self.scrollIndicatorInsets = insets;
	
	
	//content size calculation
    contentSize.width = hoursVisibleRange.length * hourWidth;
	contentSize.height = MAX(visibleRect.size.height, numberOfRows * rowHeight);
    self.contentSize = contentSize;
	
	
	//visible duration
	visibleDuration = AADurationZero;
	visibleDuration.start = (CGRectGetMinX(visibleRect) + headerWidth) / hourWidth + hoursVisibleRange.location;
	visibleDuration.length = (visibleRect.size.width - headerWidth) / hourWidth;
	visibleDuration.start = MAX(visibleDuration.start, hoursVisibleRange.location);
	visibleDuration.length = MIN(visibleDuration.length, hoursVisibleRange.length);
	
	
	//backgroundview positioning
    CGRect backgroundFrame = bounds;
	backgroundFrame.size.width = contentSize.width;
	backgroundFrame.origin.y = visibleRect.origin.y;
	backgroundFrame.origin.x = 0;
    backgroundView.frame = backgroundFrame;
	
	
	//rulerview positioning
	CGRect rulerFrame = backgroundFrame;
	rulerFrame.size.height = rulerHeight;
	rulerView.frame = rulerFrame;
	
	
	//timehead positioning
	CGRect timeheadFrame = bounds;
	timeheadFrame.size.width = kTimeheadCarotImage.size.width;
	timeheadFrame.origin.y = visibleRect.origin.y;
	timeheadFrame.origin.x = floor((contentSize.width * timeheadProgress) - (kTimeheadCarotImage.size.width / 2));
	timeheadView.frame = timeheadFrame;
	
	
	//content views sizing
	CGRect contentViewFrame = CGRectZero;
	contentViewFrame.size = contentSize;
	zoningContentView.frame = contentViewFrame;
	breakContentView.frame = contentViewFrame;
	
	contentViewFrame.origin.x = MAX(visibleRect.origin.x, -headerWidth);
	contentViewFrame.size.width = headerWidth;
	headerContentView.frame = contentViewFrame;
	
	
	//upper left fill positioning
	CGRect upperLeftFillFrame = backgroundFrame;
	upperLeftFillFrame.origin.x = MAX(visibleRect.origin.x, -headerWidth);
	upperLeftFillFrame.origin.y = MAX(visibleRect.origin.y, -rulerHeight);
	upperLeftFillFrame.size.height = MIN(visibleRect.origin.y, 0);
	upperLeftFillFrame.size.width = headerWidth;
	//upperLeftFillView.frame = upperLeftFillFrame;
	
	NSUInteger firstRow = BETWEEN(0, floor((CGRectGetMinY(visibleRect)) / rowHeight), numberOfRows);
	NSUInteger lastRow = BETWEEN(0, floor((CGRectGetMaxY(visibleRect)) / rowHeight) + 1, numberOfRows);
	
	NSRange previouslyVisibleRowsRange = visibleRowsRange;
	visibleRowsRange = NSMakeRange(firstRow, abs(firstRow - lastRow));
	
	NSRangeEnumerateUnion(previouslyVisibleRowsRange, visibleRowsRange, ^(NSUInteger row) {
		
		NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
		NSUInteger numberOfZonings = [[zoningDurations objectAtIndex:row] count];
		NSUInteger numberOfBreaks = [[breakDurations objectAtIndex:row] count];
		
		[headerViewRecycler processViewForKey:rowIndexPath];
		
		NSUIntegerEnumerate(numberOfZonings, ^(NSUInteger index) {
			
			NSIndexPath *zoningPath = [rowIndexPath indexPathByAddingIndex:index];
			[zoningViewRecycler processViewForKey:zoningPath];
		});
		
		NSUIntegerEnumerate(numberOfBreaks, ^(NSUInteger index) {
			
			NSIndexPath *breakPath = [rowIndexPath indexPathByAddingIndex:index];
			[breakViewRecycler processViewForKey:breakPath];
		});
	});
}

- (void)viewRecycler:(AAViewRecycler *)viewRecycler didLoadView:(id)view withKey:(id)key
{
	if (viewRecycler == headerViewRecycler)
	{
		ScheduleViewHeaderView *headerView = view;
		
		NSString *title = nil;
		if (delegateResponseFlags.headerTitles)
			title = [self.delegate headerTitleAtIndexPath:key inScheduleView:self];
		headerView.nameLabel.text = title;
		
		UIImage *image = nil;
		if (delegateResponseFlags.headerAccessoryImages)
			image = [self.delegate imageForHeaderAccessoryAtIndex:key inScheduleView:self];
		
		headerView.imageView.image = image;
	}
	else if (viewRecycler == zoningViewRecycler)
	{
		NSString *hexColor = nil;
		if (delegateResponseFlags.hexColors)
			hexColor = [self.delegate hexColorForZoningAtIndexPath:key inScheduleView:self];
		
		if (!hexColor) hexColor = @"dddddd";

		UIImage *image = [zoningViewTintedImages objectForKey:hexColor];
		
		if (!image)
		{
			UIColor *color = [UIColor colorWithHexString:hexColor];
			image = [ScheduleViewZoningView backgroundImageWithFillColor:color];
			[zoningViewTintedImages setObject:image forKey:hexColor];
		}
		
		ScheduleViewZoningView *zoningView = view;
		zoningView.backgroundImageView.image = image;
	}
	else if (viewRecycler == breakViewRecycler)
	{
		ScheduleViewBreakView *breakView = view;
		
		UIImage *image = nil;
		
		if (delegateResponseFlags.breakImages)
			image = [self.delegate imageForBreakAtIndexPath:key inScheduleView:self];
		
		breakView.imageView.image = image;
	}
}

- (void)calculateContentInset
{
	UIEdgeInsets insets = UIEdgeInsetsZero;
	insets.top = rulerHeight;
	insets.left = headerWidth;
	self.contentInset = insets;
}

#pragma mark - properties

@synthesize dataSource, delegate;

- (void)setDataSource:(id <ScheduleViewDataSource>)someObject
{
	dataSource = someObject;
	[self reloadSchedule];
}

- (void)setDelegate:(id <ScheduleViewDelegate>)someObject
{
	super.delegate = someObject;
	delegate = someObject;
	
	delegateResponseFlags.headerTitles = [delegate respondsToSelector:@selector(headerTitleAtIndexPath:inScheduleView:)];
	delegateResponseFlags.hexColors = [delegate respondsToSelector:@selector(hexColorForZoningAtIndexPath:inScheduleView:)];
	delegateResponseFlags.headerAccessoryImages = [delegate respondsToSelector:@selector(imageForHeaderAccessoryAtIndex:inScheduleView:)];
	delegateResponseFlags.breakImages = [delegate respondsToSelector:@selector(imageForBreakAtIndexPath:inScheduleView:)];
	delegateResponseFlags.didSelectZoningView = [delegate respondsToSelector:@selector(scheduleView:didSelectZoningViewAtIndexPath:)];
	delegateResponseFlags.didSelectBreakView = [delegate respondsToSelector:@selector(scheduleView:didSelectBreakViewAtIndexPath:)];
	
	[self reloadSchedule];
}

@synthesize rulerHeight, rowHeight, hourWidth, hoursVisibleRange, headerWidth, editing;

- (void)setRulerHeight:(CGFloat)value
{
	[self setRulerHeight:value animated:NO];
}

- (void)setBlockHeight:(CGFloat)value
{
	[self setBlockHeight:value animated:NO];
}

- (void)setHourWidth:(CGFloat)value;
{
    [self setHourWidth:value animated:NO];
}

- (void)setHoursVisibleRange:(NSRange)value
{
    hoursVisibleRange = value;
	backgroundView.hoursVisibleRange = value;
    [self setNeedsLayout];
    [backgroundView setNeedsDisplay];
}

- (void)setHeaderWidth:(CGFloat)value
{
    [self setHeaderWidth:value animated:NO];
}

- (void)setEditing:(BOOL)value
{
	[self setEditing:value animated:NO];
}

#pragma mark - date and time

@synthesize referenceDate;

@synthesize timeheadDisplayDate, visibleDuration;

- (void)setTimeheadDisplayDate:(NSDate *)value
{
	NSDate *oldDate = timeheadDisplayDate;
	timeheadDisplayDate = value;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:timeheadDisplayDate];
	float currentAdjustedHour = components.hour + ((float)components.minute / 60) - hoursVisibleRange.location;
	timeheadProgress = currentAdjustedHour / hoursVisibleRange.length;
	timeheadProgress = BETWEEN(0, timeheadProgress, 1);
	
	[self setNeedsLayout];
}

#pragma mark - animation

- (void)layoutSubviewsAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.35 animations:^{
            
            [self layoutSubviews];
            
        }];
    }
    else [self setNeedsLayout];
}

- (void)setRulerHeight:(CGFloat)value animated:(BOOL)animated
{
    rulerHeight = value;
	backgroundView.rulerHeight = value;
	[self layoutSubviewsAnimated:animated];
}

- (void)setBlockHeight:(CGFloat)value animated:(BOOL)animated
{
    rowHeight = value;
	[self layoutSubviewsAnimated:animated];
}

- (void)setHourWidth:(CGFloat)value animated:(BOOL)animated
{
    hourWidth = value;
    [self layoutSubviewsAnimated:animated];
}

- (void)setHeaderWidth:(CGFloat)value animated:(BOOL)animated
{
    headerWidth = value;
    [self layoutSubviewsAnimated:animated];
}

- (void)setEditing:(BOOL)value animated:(BOOL)animated
{
	editing = value;

	[viewRecyclers makeObjectsPerformSelector:@selector(clearSelection)];
	
	[self layoutSubviews];
	
	for (AAViewRecycler *viewRecycler in viewRecyclers) [viewRecycler setEditing:editing animated:animated];
}

#pragma mark - data mutation

- (void)reloadVisibleRows
{
	NSRangeEnumerate(visibleRowsRange, ^(NSUInteger index) {
		
		//TODO: breaks and shifts
		
	});
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)reloadBreakAtIndexPath:(NSIndexPath *)breakPath animated:(BOOL)animated
{
	ScheduleViewBreakView *breakView = [breakViewRecycler visibleViewForKey:breakPath];
	
	
	//update cache
	NSValue *newValue = NSValueFromScheduleViewObject([self.dataSource breakObjectForIndexPath:breakPath inScheduleView:self], [NSDate today]);
	[[breakDurations objectAtIndex:[breakPath indexAtPosition:1]] replaceObjectAtIndex:[breakPath indexAtPosition:2] withObject:newValue];
	
	if (breakView)
	{	
		[UIView animateWithDuration:!animated ?: 0.35 animations:^{
			
			breakView.frame = [self rectForBreakAtIndexPath:breakPath];
			[breakViewRecycler setView:breakView forKey:breakPath];
		}];
	}
}

#pragma mark - zoning colors

@synthesize zoningViewHexColors;

- (void)setZoningViewHexColors:(NSSet *)hexColors
{
	[zoningViewTintedImages removeAllObjects];
	
	for (NSString *hexColor in hexColors)
	{
		UIColor *color = [UIColor colorWithHexString:hexColor];
		UIImage *image = [ScheduleViewZoningView backgroundImageWithFillColor:color];
		[zoningViewTintedImages setValue:image forKey:hexColor];
	}
	
	[self reloadSchedule];
}

#pragma mark - selection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	if (!numberOfRows) return;
	
	UITouch *touch = [touches anyObject];
	CGPoint tapPoint = [touch locationInView:self];
	
	if (tapPoint.x <= 0 && tapPoint.y >= 0)
	{
		if (!editing) return;
		NSUInteger selectedHeaderIndex = BETWEEN(0, floor((tapPoint.y) / rowHeight), numberOfRows);
		NSNumber *key = [NSNumber numberWithUnsignedInteger:selectedHeaderIndex];
		ScheduleViewHeaderView *headerView = [headerViewRecycler visibleViewForKey:key];
		[headerView setHighlighted];
		headerViewRecycler.keyForCurrentlyTouchedView = key;
	}
	else if (tapPoint.x >= 0 && tapPoint.y >= 0)
	{
		NSUInteger selectedRowIndex = BETWEEN(0, floor((tapPoint.y) / rowHeight), numberOfRows);
		NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:selectedRowIndex inSection:0];
		
		__block ScheduleViewZoningView *selectedZoningView = nil;
		
		NSUIntegerEnumerate([[zoningDurations objectAtIndex:selectedRowIndex] count], ^(NSUInteger index) {
			
			NSIndexPath *zoningPath = [rowIndexPath indexPathByAddingIndex:index];
			ScheduleViewZoningView *zoningView = [zoningViewRecycler visibleViewForKey:zoningPath];
			
			if (CGRectContainsPoint(zoningView.frame, tapPoint))
			{
				selectedZoningView = zoningView;
				zoningViewRecycler.keyForCurrentlyTouchedView = zoningPath;
			}
		});
		
		__block ScheduleViewBreakView *selectedBreakView = nil;
		
		NSUIntegerEnumerate([[breakDurations objectAtIndex:selectedRowIndex] count], ^(NSUInteger index) {
			
			NSIndexPath *breakPath = [rowIndexPath indexPathByAddingIndex:index];
			ScheduleViewBreakView *breakView = [breakViewRecycler visibleViewForKey:breakPath];
			
			if (CGRectContainsPoint(breakView.frame, tapPoint))
			{
				selectedBreakView = breakView;
				breakViewRecycler.keyForCurrentlyTouchedView = breakPath;
			}
		});
		
		if (selectedBreakView)
		{
			zoningViewRecycler.keyForCurrentlyTouchedView = nil;
		}
		else if (selectedZoningView && editing)
		{
			[selectedZoningView setHighlighted];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!numberOfRows) return;
	CGPoint tapPoint = [[touches anyObject] locationInView:self];
	
	if (headerViewRecycler.keyForCurrentlyTouchedView)
	{
		if (!editing) return;
		ScheduleViewHeaderView *headerView = [headerViewRecycler currentlyTouchedView];
		CGRect convertedFrame = [headerContentView convertRect:headerView.frame toView:self];
		
		if (CGRectContainsPoint(convertedFrame, tapPoint)) [headerViewRecycler toggleSelectionForCurrentlyTouchedView];
	}
	else if (zoningViewRecycler.keyForCurrentlyTouchedView)
	{
		ScheduleViewZoningView *zoningView = [zoningViewRecycler currentlyTouchedView];
		
		if (CGRectContainsPoint(zoningView.frame, tapPoint))
		{
			if (editing) [zoningViewRecycler toggleSelectionForCurrentlyTouchedView];
			else if (delegateResponseFlags.didSelectZoningView)
				[self.delegate scheduleView:self didSelectZoningViewAtIndexPath:zoningViewRecycler.keyForCurrentlyTouchedView];
		}
	}
	else if (breakViewRecycler.keyForCurrentlyTouchedView)
	{
		if (delegateResponseFlags.didSelectBreakView)
			[self.delegate scheduleView:self didSelectBreakViewAtIndexPath:breakViewRecycler.keyForCurrentlyTouchedView];
	}
	
	[self touchesCancelled:nil withEvent:nil];
}

- (void)viewRecycler:(AAViewRecycler *)someViewReuseController selectViewWithKey:(id)key selected:(BOOL)isSelected
{
	ScheduleViewCell *cell = [someViewReuseController visibleViewForKey:key];
	cell.selected = isSelected;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[viewRecyclers makeObjectsPerformSelector:@selector(refreshSelectionForCurrentlyTouchedView)];
	[viewRecyclers setValue:nil forKey:@"keyForCurrentlyTouchedView"];
}

#pragma - scrolling

- (void)scrollToBreakAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
	[self scrollRectToVisible:[self rectForBreakAtIndexPath:indexPath] animated:animated];
}

#pragma mark - cache

static CGFloat AANumberOfIntervals(CGFloat originalValue, CGFloat intervalAmount)
{
	CGFloat remainder = fmod(originalValue, intervalAmount);
	CGFloat numberOfIntervals = (originalValue - remainder) / intervalAmount;
	return (remainder / intervalAmount) + numberOfIntervals;
};

static NSValue *NSValueFromScheduleViewObject(id <ScheduleViewObject> someObject, NSDate *relativeDate)
{	
	NSTimeInterval startTimeInterval = [someObject.scheduledStartDate timeIntervalSinceDate:relativeDate];
	NSTimeInterval endTimeInterval = [someObject.scheduledEndDate timeIntervalSinceDate:relativeDate];
	
	static NSTimeInterval numberOfSecondsInAnHour = 3600;
	
	AADuration duration = AADurationZero;
	duration.start = AANumberOfIntervals(startTimeInterval, numberOfSecondsInAnHour);
	duration.length = (AANumberOfIntervals(endTimeInterval, numberOfSecondsInAnHour) - duration.start);
	
	
	return [NSValue valueWithBytes:&duration objCType:@encode(AADuration)];
};

- (void)reloadCache
{
	
	numberOfRows = [dataSource numberOfShiftsInSection:0 inScheduleView:self];
	
	shiftDurations = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
	zoningDurations = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
	breakDurations = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
	
	NSDate *relativeDate = [NSDate today];
	
	for (int rowIndex = 0; rowIndex < numberOfRows; rowIndex++)
	{
		NSIndexPath *shiftIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0]; //when sections are added, we need to ask for a section
		id <ScheduleViewObject> scheduleViewObject = [self.dataSource shiftObjectForIndexPath:shiftIndexPath inScheduleView:self];
		[shiftDurations addObject:NSValueFromScheduleViewObject(scheduleViewObject, relativeDate)];
			
		
		NSUInteger numberOfZoningsThisShift = [self.dataSource numberOfZoningsAtIndexPath:shiftIndexPath inScheduleView:self];
		NSUInteger numberOfBreaksThisShift = [self.dataSource numberOfBreaksAtIndexPath:shiftIndexPath inScheduleView:self];
		
		
		NSMutableArray *zonings = [NSMutableArray new];
		
		for (int j = 0; j < numberOfZoningsThisShift; j++)
		{
			NSIndexPath *indexPath = [shiftIndexPath indexPathByAddingIndex:j];
			id <ScheduleViewObject> scheduleViewObject = [self.dataSource zoningObjectForIndexPath:indexPath inScheduleView:self];
			[zonings addObject:NSValueFromScheduleViewObject(scheduleViewObject, relativeDate)];
		}
		
		[zoningDurations addObject:zonings];
		
		
		NSMutableArray *breaks = [NSMutableArray new];
		
		for (int j = 0; j < numberOfBreaksThisShift; j++)
		{
			NSIndexPath *indexPath = [shiftIndexPath indexPathByAddingIndex:j];
			id <ScheduleViewObject> scheduleViewObject = [self.dataSource breakObjectForIndexPath:indexPath inScheduleView:self];
			[breaks addObject:NSValueFromScheduleViewObject(scheduleViewObject, relativeDate)];
		}
		
		[breakDurations addObject:breaks];
	}
}

- (void)reloadSchedule
{
	[self reloadCache];
	
	[viewRecyclers makeObjectsPerformSelector:@selector(cacheAllViews)];
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
	[viewRecyclers makeObjectsPerformSelector:@selector(removeAllCachedViews)];
}


@end
