//
//  Shift.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/23/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "Shift.h"
#import "Break.h"
#import "Employee.h"
#import "Zoning.h"


@implementation Shift

@dynamic breaks;
@dynamic employee;
@dynamic zonings;

- (ShiftType)type
{
	NSInteger duration = [NSDate hundredsMinuteIntegerFromTimeInterval:self.duration];
	
    if (duration < 400) return ShiftTypeNoBreaks;
    else if (duration < 500) return ShiftTypeOneBreak;
    else if (duration < 600) return ShiftTypeTwoBreaks;
    else if (duration < 700) return ShiftTypeOneBreakAndOneHalfLunch;
    else return ShiftTypeTwoBreaksAndOneFullLunch;
}

- (void)standardizeBreaks
{
	NSMutableArray *breaks = [NSMutableArray new];
	
	switch (self.type)
	{
		case ShiftTypeNoBreaks:
			break;
			
		case ShiftTypeOneBreak:
		{
			Break *breakOne = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakOne.type = BreakTypeFifteen;
			
			[breaks addObject:breakOne];
		}
			break;
			
		case ShiftTypeTwoBreaks:
		{
			Break *breakOne = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakOne.type = BreakTypeFifteen;
			
			Break *breakTwo = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakTwo.type = BreakTypeFifteen;
			
			[breaks addObject:breakOne];
			[breaks addObject:breakTwo];
		}
			break;
			
		case ShiftTypeOneBreakAndOneHalfLunch:
		{
			Break *breakOne = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakOne.type = BreakTypeFifteen;
			
			Break *breakTwo = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakTwo.type = BreakTypeHalfLunch;
			
			[breaks addObject:breakOne];
			[breaks addObject:breakTwo];
		}
			break;
			
		case ShiftTypeTwoBreaksAndOneFullLunch:
		default:
		{
			Break *breakOne = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakOne.type = BreakTypeFifteen;
			
			Break *breakTwo = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakTwo.type = BreakTypeFullLunch;
			
			Break *breakThree = [NSEntityDescription insertNewObjectForEntityForName:@"Break" inManagedObjectContext:self.managedObjectContext];
			breakThree.type = BreakTypeFifteen;
			
			[breaks addObject:breakOne];
			[breaks addObject:breakTwo];
			[breaks addObject:breakThree];
		}
			break;
	}
	
	NSTimeInterval interval = (self.duration - [[breaks valueForKeyPath:@"@sum.type"] doubleValue]) / (breaks.count + 1);
	NSTimeInterval breakStart = interval + [self.start timeIntervalSinceReferenceDate];
	
	for (Break *breakObject in breaks)
	{
		NSTimeInterval duration = breakObject.type;
		
		breakObject.start = [NSDate dateWithTimeIntervalSinceReferenceDate:breakStart];
		breakObject.end = [breakObject.start dateByAddingTimeInterval:duration];
		breakStart += duration + interval;
	}
	
	self.breaks = [NSOrderedSet orderedSetWithArray:breaks];
	[breaks release];
}


@end
