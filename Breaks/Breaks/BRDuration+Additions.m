//
//  BRDuration+Additions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRDuration+Additions.h"

#import "NSDate+ScheduleViewDateAdditions.h"
#import "BRScheduleDuration.h"


@implementation BRDuration (Additions)

- (BOOL)containsDate:(NSDate *)date
{
	BOOL containsDate = [self.scheduledStartDate isEarlierThanDate:date] && [self.scheduledEndDate isLaterThanDate:date];
	return containsDate;
}

- (BRScheduleDuration *)portableDuration
{
    BRScheduleDuration *scheduleDuration = [BRScheduleDuration new];
    scheduleDuration.startDate = self.scheduledStartDate;
    scheduleDuration.endDate = self.scheduledEndDate;
    return scheduleDuration;
}

@end
