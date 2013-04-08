//
//  ScheduleRulerView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleRulerView.h"

#import "ScheduleView.h"


@implementation ScheduleRulerView

- (id)initWithTable:(ScheduleView *)someTable
{
    if (self = [super initWithFrame:CGRectZero])
	{
		superTable = someTable;
		
		self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
	CGFloat increment = superTable.hourWidth;
	CGFloat offset = superTable.employeeHeaderWidth;
	
	[[UIColor darkGrayColor] set];
	
	for (float i = 0; i < superTable.hoursVisibleRange.length; i += 0.5)
	{
		CGFloat currentXPosition = floor(i * increment) + offset;
		CGRect currentSegmentRect = bounds;
		currentSegmentRect.origin.x = currentXPosition;
		currentSegmentRect.size.width = 1;
		
		float round = fmodf(i, 2);
		BOOL minorTick = round != 0 && round != 1;
		if (minorTick)
		{
			currentSegmentRect.origin.y += currentSegmentRect.size.height / 2;
			currentSegmentRect.size.height /= 2;
		}
		
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:currentSegmentRect];
		[path fill];
		
		if (!minorTick)
		{
			NSString *label = [NSString stringWithFormat:@"%.0f", i + superTable.hoursVisibleRange.location];
			CGPoint textPoint = currentSegmentRect.origin;
			textPoint.x += 2;
			[label drawAtPoint:textPoint withFont:[UIFont systemFontOfSize:16]];
		}
	}
}

@end
