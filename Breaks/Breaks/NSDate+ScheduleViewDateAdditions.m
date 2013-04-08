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

+ (NSTimeInterval)timeIntervalFromHundredsMinuteInteger:(NSInteger)value
{
	NSUInteger minutes = value % 100;
	NSUInteger hours = (value - minutes) / 100;
	
	NSTimeInterval timeInterval = hours * 3600;
	timeInterval += minutes * 36;
	
	return timeInterval;
}

+ (NSInteger)hundredsMinuteIntegerFromTimeInterval:(NSTimeInterval)value
{
	NSTimeInterval minutes = fmod(value, 3600);
	NSTimeInterval hours = (value - minutes) / 3600;
	
	NSInteger minutesInteger = hours * 100;
	minutesInteger += minutes / 60 * 10 / 6;
	
	return minutesInteger;
}

- (NSTimeInterval)timeIntervalSinceToday
{
	return [self timeIntervalSinceDate:[NSDate today]];
}

- (NSInteger)timeIntervalFromTodayAsHundredsMinuteInteger
{
	return [NSDate hundredsMinuteIntegerFromTimeInterval:[self timeIntervalSinceToday]];
}


@end
