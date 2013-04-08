//
//  ScheduleBackgroundView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewBackground.h"

#import "ScheduleView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ScheduleViewBackground

- (id)initWithScheduleView:(ScheduleView *)someSchedule
{
   if (self = [super initWithScheduleView:someSchedule]) 
	{
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeRedraw;
		//self.clipsToBounds = NO;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return scheduleView.contentSize;
}

- (void)drawRect:(CGRect)rect
{
	CGRect bounds = self.bounds;
	CGFloat increment = self.scheduleView.hourWidth;
	CGFloat offset = self.scheduleView.headerWidth;
	
	[[UIColor darkGrayColor] set];
	
//	for (int i = 1; i < self.scheduleView.hoursVisibleRange.length; i++)
//	{
//		CGFloat currentXPosition = floor(i * increment) + offset;
//		CGRect currentSegmentRect = bounds;
//		currentSegmentRect.origin.x = currentXPosition;
//		currentSegmentRect.size.width = 1;
//		UIBezierPath *path = [UIBezierPath bezierPathWithRect:currentSegmentRect];
//		[path fill];
//	}
	
	for (float i = 0; i < self.scheduleView.hoursVisibleRange.length; i += 0.5)
	{
		CGFloat currentXPosition = floor(i * increment) + offset;
		CGRect currentSegmentRect = bounds;
		currentSegmentRect.origin.x = currentXPosition;
		currentSegmentRect.size.width = 1;
		
		float round = fmodf(i, 2);
		BOOL minorTick = round != 0 && round != 1;
		if (minorTick)
		{
			currentSegmentRect.size.height = 20;
			currentSegmentRect.origin.y += currentSegmentRect.size.height / 2;
			currentSegmentRect.size.height /= 2;
		}
		
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:currentSegmentRect];
		[path fill];
		
		if (!minorTick)
		{
			NSString *label = [NSString stringWithFormat:@"%.0f", i + self.scheduleView.hoursVisibleRange.location];
			CGPoint textPoint = currentSegmentRect.origin;
			textPoint.x += 2;
			[label drawAtPoint:textPoint withFont:[UIFont systemFontOfSize:16]];
		}
	}

}

@end
