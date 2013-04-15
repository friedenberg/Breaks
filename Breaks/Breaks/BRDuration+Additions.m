//
//  BRDuration+Additions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRDuration+Additions.h"

#import "NSDate+ScheduleViewDateAdditions.h"


@implementation BRDuration (Additions)

- (BOOL)containsDate:(NSDate *)date
{
	BOOL containsDate = [self.scheduledStartDate isEarlierThanDate:date] && [self.scheduledEndDate isLaterThanDate:date];
	return containsDate;
}

@end
