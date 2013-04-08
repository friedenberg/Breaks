//
//  NSDate+ScheduleViewDateAdditions.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/10/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ScheduleViewDateAdditions)

+ (NSDate *)today;

- (BOOL)isLaterThanDate:(NSDate *)date;
- (BOOL)isEarlierThanDate:(NSDate *)date;

+ (NSTimeInterval)timeIntervalFromHundredsMinuteInteger:(NSInteger)value;
+ (NSInteger)hundredsMinuteIntegerFromTimeInterval:(NSTimeInterval)value;

- (NSTimeInterval)timeIntervalSinceToday;
- (NSInteger)timeIntervalFromTodayAsHundredsMinuteInteger;

@end
