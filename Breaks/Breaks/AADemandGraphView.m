//
//  AABezierGraphView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/16/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AADemandGraphView.h"

#import "AADemandGraphColumnView.h"
#import "AAGraphLayerView.h"
#import "ScheduleViewBackgroundView.h"

#import "AAViewRecycler.h"

#import "UIBezierPath+Convenience.h"


@interface AADemandGraphView ()



@end

@implementation AADemandGraphView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		self.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
		
		self.directionalLockEnabled = YES;
		self.canCancelContentTouches = NO;
		
		columnData = [NSMutableDictionary new];
		
		self.rangeOfHours = NSMakeRange(7, 18);
		hourWidth = 44;
		unitHeight = 44;
		
		columnViewRecycler = [[AAViewRecycler alloc] initWithDelegate:self];
		
		backgroundView = [[ScheduleViewBackgroundView alloc] initWithFrame:CGRectZero];
		backgroundView.hoursVisibleRange = NSMakeRange(7, 18);
		backgroundView.rulerHeight = 20;
		backgroundView.showsRuler = YES;
		[self addSubview:backgroundView];
		
		columnContentView = [UIView new];
		[self addSubview:columnContentView];
	}
	
	return self;
}

@synthesize hourWidth, rangeOfHours, unitHeight;

- (void)setRangeOfHours:(NSRange)value
{
	rangeOfHours = value;
	[columnData removeAllObjects];
	
	NSRangeEnumerate(rangeOfHours, ^(NSUInteger index) {
		
		[columnData setObject:[NSNumber numberWithUnsignedInteger:3] 
					   forKey:[NSNumber numberWithUnsignedInteger:index]];
	});
}

#define BETWEEN(lower, value, upper) MAX(lower, MIN(upper, value))

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	CGSize contentSize = CGSizeMake(rangeOfHours.length * hourWidth, bounds.size.height - self.contentInset.bottom);
	self.contentSize = contentSize;
	CGRect contentSizeBounds = CGRectZero;
	contentSizeBounds.size = contentSize;
	
	backgroundView.frame = contentSizeBounds;
	columnContentView.frame = contentSizeBounds;
	
	CGRect visibleRect = CGRectZero;
	visibleRect.size = bounds.size;
	visibleRect.origin = self.contentOffset;
	
	NSUInteger firstColumn = BETWEEN(0, floor((CGRectGetMinX(visibleRect)) / hourWidth), rangeOfHours.length);
	NSUInteger lastColumn = BETWEEN(0, floor((CGRectGetMaxX(visibleRect)) / hourWidth) + 1, rangeOfHours.length);
	
	NSRange previouslyVisibleRange = visibleRange;
	visibleRange = NSMakeRange(firstColumn, lastColumn - firstColumn);
	
	NSRangeEnumerateUnion(previouslyVisibleRange, visibleRange, ^(NSUInteger index) {
		
		NSNumber *key = [NSNumber numberWithUnsignedInteger:index];
		[columnViewRecycler processViewForKey:key];
	});
}

- (UIView <AAViewRecycling> *)unusedViewForViewRecycler:(AAViewRecycler *)someViewRecycler
{
	if (someViewRecycler == columnViewRecycler)
	{
		return [AADemandGraphColumnView new];
	}
	else @throw [NSException exceptionWithName:NSGenericException reason:@"wrong view recycler!" userInfo:nil];
}

- (BOOL)visibilityForKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler
{
	if (someViewRecycler == columnViewRecycler)
	{
		NSNumber *index = key;
		return NSLocationInRange([index unsignedIntegerValue], visibleRange);
	}
	else @throw [NSException exceptionWithName:NSGenericException reason:@"wrong view recycler!" userInfo:nil];
}

- (CGRect)rectForViewWithKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler
{
	if (someViewRecycler == columnViewRecycler)
	{
		NSNumber *indexNumber = key;
		NSUInteger index = [indexNumber unsignedIntegerValue];
		NSNumber *dataNumber = [NSNumber numberWithUnsignedInteger:index + rangeOfHours.location];
		NSUInteger columnUnits = [[columnData objectForKey:dataNumber] unsignedIntegerValue];
		
		CGRect rect = CGRectZero;
		rect.origin.x = index * hourWidth;
		rect.size.width = hourWidth;
		rect.size.height = columnUnits * unitHeight;
		rect.origin.y = self.contentSize.height - rect.size.height;
		return CGRectInsetFromLeft(rect, 1);
	}
	else @throw [NSException exceptionWithName:NSGenericException reason:@"wrong view recycler!" userInfo:nil];
}

- (UIView *)superviewForViewWithKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler
{
	if (someViewRecycler == columnViewRecycler)
	{
		return columnContentView;
	}
	else @throw [NSException exceptionWithName:NSGenericException reason:@"wrong view recycler!" userInfo:nil];
}

- (void)viewRecycler:(AAViewRecycler *)someViewReuseController didLoadView:(UIView<AAViewEditing> *)view withKey:(id)key
{
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	CGPoint tapPoint = [touch locationInView:self];
	
    NSUInteger index = floor(tapPoint.x / hourWidth);
	NSNumber *key = [NSNumber numberWithUnsignedInteger:index];
	
	AADemandGraphColumnView *columnView = [columnViewRecycler visibleViewForKey:key];
	CGPoint localPoint = [touch locationInView:columnView];
	
	UIView *hitTest = [columnView hitTest:localPoint withEvent:nil];
	BOOL shouldMove = hitTest == columnView.controlPointView;
	
	if (shouldMove) columnViewRecycler.keyForCurrentlyTouchedView = key;
	else columnViewRecycler.keyForCurrentlyTouchedView = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	CGPoint tapPoint = [touch locationInView:self];
	
    NSUInteger index = floor(tapPoint.x / hourWidth);
	NSNumber *key = [NSNumber numberWithUnsignedInteger:index];
	
	if ([columnViewRecycler.keyForCurrentlyTouchedView isEqual:key])
	{
		CGFloat tapHeightFromBottom = self.contentSize.height - tapPoint.y;
		CGFloat granularity = unitHeight / 2;
		CGFloat remainder = fmod(tapHeightFromBottom, unitHeight);
		
		NSUInteger columnUnit = tapHeightFromBottom / unitHeight;
		if (remainder > granularity) columnUnit++;
		
		NSNumber *indexNumber = [NSNumber numberWithUnsignedInteger:index + rangeOfHours.location];
		NSNumber *columnUnitNumber = [NSNumber numberWithUnsignedInteger:columnUnit];
		
		[columnData setObject:columnUnitNumber forKey:indexNumber];
		
		[self setNeedsLayout];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	columnViewRecycler.keyForCurrentlyTouchedView = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	
	columnViewRecycler.keyForCurrentlyTouchedView = nil;
}


@end
