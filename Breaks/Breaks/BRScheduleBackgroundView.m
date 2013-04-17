//
//  BRScheduleBackgroundView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleBackgroundView.h"

#import "BRScheduleView.h"


@implementation BRScheduleBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeRedraw;
		self.clipsToBounds = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGRect bounds = self.bounds;
    
    NSRange hoursVisibleRange = _scheduleView.hoursVisibleRange;
    CGFloat hourWidth = _scheduleView.hourWidth;
    CGFloat rulerHeight = _scheduleView.rulerHeight;
	
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


@end
