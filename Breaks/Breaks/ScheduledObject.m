//
//  ScheduledObject.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduledObject.h"


@implementation ScheduledObject

@dynamic start;
@dynamic end;

- (NSTimeInterval)duration
{
	return [self.end timeIntervalSinceDate:self.start];
}

- (void)setDuration:(NSTimeInterval)duration
{
	self.end = [self.start dateByAddingTimeInterval:duration];
}

- (BOOL)containsDate:(NSDate *)date
{
	BOOL containsDate = [self.start isEarlierThanDate:date] && [self.end isLaterThanDate:date];
	return containsDate;
}

@end