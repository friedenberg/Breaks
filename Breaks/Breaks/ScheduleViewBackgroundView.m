//
//  ScheduleBackgroundView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewBackgroundView.h"

#import "ScheduleView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ScheduleViewBackgroundView

- (id)initWithFrame:(CGRect)frame
{
   if (self = [super initWithFrame:frame]) 
	{
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeRedraw;
		self.clipsToBounds = NO;
		
//		CALayer *layer = self.layer;
//		
//		layer.shadowOffset = CGSizeMake(0, 1.25);
//		layer.shadowOpacity = 0.7;
//		layer.shadowRadius = 1.5;
    }
    return self;
}

@synthesize rulerHeight, hoursVisibleRange;

- (void)drawRect:(CGRect)rect
{
	CGRect bounds = self.bounds;
	CGFloat hourWidth = bounds.size.width / hoursVisibleRange.length;
	
	for (float i = 0; i < hoursVisibleRange.length; i += 0.5)
	{
		CGFloat currentXPosition = floor(i * hourWidth);
		CGRect currentSegmentRect = bounds;
		currentSegmentRect.origin.x = currentXPosition;
		currentSegmentRect.size.width = 1;
		
		float round = fmodf(i, 2);
		BOOL minorTick = round != 0 && round != 1;
		
		if (minorTick && self.showsRuler)
		{
			currentSegmentRect.size.height = rulerHeight;
			currentSegmentRect.origin.y += currentSegmentRect.size.height / 2;
			currentSegmentRect.size.height /= 2;
		}
		
		[[UIColor lightGrayColor] set];
		
		UIBezierPath *path = [UIBezierPath bezierPathWithRect:currentSegmentRect];
		[path fill];
		
		if (!minorTick && self.showsRuler)
		{
			[[UIColor darkGrayColor] set];
			NSString *label = [NSString stringWithFormat:@"%.0f", (fmodf((i + hoursVisibleRange.location), 24))];
			CGPoint textPoint = currentSegmentRect.origin;
			textPoint.x += 2;
			[label drawAtPoint:textPoint withFont:[UIFont systemFontOfSize:rulerHeight]];
		}
	}
}

@synthesize showsRuler;

@end
