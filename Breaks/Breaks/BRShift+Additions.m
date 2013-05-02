//
//  BRStoreShift+Additions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRShift+Additions.h"

#import "BRZone.h"
#import "BRZoning.h"
#import "BRDuration.h"
#import "BRBreak+Additions.h"
#import "BRDuration+Additions.h"


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
	
	NSTimeInterval interval = (self.duration.scheduledDuration - [[breaks valueForKeyPath:@"@sum.type"] doubleValue]) / (breaks.count + 1);
	NSTimeInterval breakStart = interval + [self.duration.scheduledStartDate timeIntervalSinceReferenceDate];
	
	for (BRBreak *breakObject in breaks)
	{
		NSTimeInterval duration = (NSTimeInterval)breakObject.type;
		
		breakObject.duration.scheduledStartDate = [NSDate dateWithTimeIntervalSinceReferenceDate:breakStart];
		breakObject.duration.scheduledEndDate = [breakObject.duration.scheduledStartDate dateByAddingTimeInterval:duration];
		breakStart += duration + interval;
	}
	
	self.breaks = [NSOrderedSet orderedSetWithArray:breaks];
}

- (NSString *)titleForCurrentActivity
{
    NSString *title = @"Off";
    NSDate *now = [NSDate date];
    __block BRBreak *currentBreak = nil;
    
    [self.breaks enumerateObjectsUsingBlock:^(BRBreak *someBreak, NSUInteger idx, BOOL *stop) {
        
        if ([someBreak.duration containsDate:now]) {
            currentBreak = someBreak;
            *stop = YES;
        }
        
    }];
    
    if (currentBreak) {
        switch (currentBreak.type) {
            case BRBreakTypeFifteen:
                title = @"Break";
                break;
                
            case BRBreakTypeHalfLunch:
                title = @"Half Lunch";
                break;
                
            case BRBreakTypeFullLunch:
            default:
                title = @"Lunch";
                break;
        }
    } else {
        __block BRZoning *currentZoning = nil;
        
        [self.zonings enumerateObjectsUsingBlock:^(BRZoning *someZoning, NSUInteger idx, BOOL *stop) {
            
            if ([someZoning.duration containsDate:now]) {
                currentZoning = someZoning;
                *stop = YES;
            }
            
        }];
        
        if (currentZoning) {
            title = currentZoning.sectionZone.name;
        }
    }
    
    return title;
}

@end