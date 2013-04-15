//
//  BRStoreShift+Additions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRStoreShift+Additions.h"

#import "BRDuration.h"
#import "BRShiftBreak+Additions.h"


@implementation BRShift (Additions)

- (BRShiftType)shiftType;
{
	BRTimeInterval duration = self.duration.scheduledDuration;
    
    if (duration < 3600 * 4) return BRShiftTypeNoBreaks;
    else if (duration < 3600 * 5) return BRShiftTypeOneBreak;
    else if (duration < 3600 * 6) return BRShiftTypeTwoBreaks;
    else if (duration < 3600 * 7) return BRShiftTypeOneBreakAndOneHalfLunch;
    else return BRShiftTypeTwoBreaksAndOneFullLunch;
}

- (void)standardizeBreaks
{
	NSArray *breaks = nil;
	
	switch (self.shiftType)
	{
		case BRShiftTypeOneBreak:
		{
            breaks = [BRBreak shiftBreaksWithDurations:@[@(BRBreakTypeFifteen)] managedObjectContext:self.managedObjectContext];
		}
			break;
			
		case BRShiftTypeTwoBreaks:
		{
			breaks = [BRBreak shiftBreaksWithDurations:@[@(BRBreakTypeFifteen), @(BRBreakTypeFifteen)] managedObjectContext:self.managedObjectContext];
		}
			break;
			
		case BRShiftTypeOneBreakAndOneHalfLunch:
		{
            breaks = [BRBreak shiftBreaksWithDurations:@[@(BRBreakTypeFifteen), @(BRBreakTypeHalfLunch)] managedObjectContext:self.managedObjectContext];
		}
			break;
			
		case BRShiftTypeTwoBreaksAndOneFullLunch:
		default:
		{
            breaks = [BRBreak shiftBreaksWithDurations:@[@(BRBreakTypeFifteen), @(BRBreakTypeFullLunch), @(BRBreakTypeFifteen)] managedObjectContext:self.managedObjectContext];
		}
			break;
	}
	
	NSTimeInterval interval = (self.duration.scheduledDuration - [[breaks valueForKeyPath:@"@sum.duration.scheduledDuration"] doubleValue]) / (breaks.count + 1);
	NSTimeInterval breakStart = interval + [self.duration.scheduledStartDate timeIntervalSinceReferenceDate];
	
	for (BRBreak *breakObject in breaks)
	{
		NSTimeInterval duration = breakObject.duration.scheduledDuration;
		
		breakObject.duration.scheduledStartDate = [NSDate dateWithTimeIntervalSinceReferenceDate:breakStart];
		breakObject.duration.scheduledEndDate = [breakObject.duration.scheduledStartDate dateByAddingTimeInterval:duration];
		breakStart += duration + interval;
	}
	
	self.breaks = [NSOrderedSet orderedSetWithArray:breaks];
}


@end
