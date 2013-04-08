//
//  ScheduleViewDataTypes.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewDataTypes.h"


const AADuration AADurationZero = {(CGFloat)0, (CGFloat)0};

AADuration AADurationMake(CGFloat start, CGFloat length)
{
	return (AADuration){start, length};
};

extern AADuration AADurationFromNSRange(NSRange range)
{
	return AADurationMake(range.location, range.length);
}

BOOL AADurationsEqual(AADuration a, AADuration b)
{
	return a.start == b.start && a.length == b.length;
}

CGFloat AADurationMax(AADuration duration)
{
	return duration.start + duration.length;
}

BOOL AADurationContainsValue(AADuration duration, CGFloat value)
{
	return value >= duration.start && value < AADurationMax(duration);
}

BOOL AADurationsOverlap(AADuration a, AADuration b)
{
	BOOL cond1 = AADurationContainsValue(a, b.start);
	BOOL cond2 = AADurationContainsValue(a, AADurationMax(b));
	
	return cond1 || cond2 || (AADurationsEqual(a, b));
}

NSString *NSStringFromAADuration(AADuration duration)
{
	return [NSString stringWithFormat:@"duration: {start: %f, length: %f}", duration.start, duration.length];
};