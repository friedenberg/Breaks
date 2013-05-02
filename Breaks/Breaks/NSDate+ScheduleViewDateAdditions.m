//
//  NSDate+ScheduleViewDateAdditions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/10/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "NSDate+ScheduleViewDateAdditions.h"

@implementation NSDate (ScheduleViewDateAdditions)

+ (NSDate *)today
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *now = [NSDate date];
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:now];
	return [calendar dateFromComponents:dateComponents];
}

- (BOOL)isLaterThanDate:(NSDate *)date
{
	return [self laterDate:date] == self;
}

- (BOOL)isEarlierThanDate:(NSDate *)date
{
	return [self earlierDate:date] == self;
}

- (NSTimeInterval)timeIntervalSinceToday
{
	return [self timeIntervalSinceDate:[NSDate today]];
}

@end
