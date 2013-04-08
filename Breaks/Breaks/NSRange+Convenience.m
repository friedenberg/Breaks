//
//  NSRange+Convenience.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/25/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "NSRange+Convenience.h"


void NSUIntegerEnumerate(NSUInteger count, NSUIntegerEnumerationBlock enumerationBlock)
{
	for (int i = 0; i < count; i++) enumerationBlock(i);
};


NSRange NSRangeFromValues(NSUInteger a, NSUInteger b)
{
	return NSMakeRange(MIN(a, b), abs(a - b));
};

void NSRangeEnumerate(NSRange range, NSUIntegerEnumerationBlock enumerationBlock)
{
	NSUInteger maxRange = NSMaxRange(range);
	for (int i = range.location; i < maxRange; i++) enumerationBlock(i);
};

void NSRangeEnumerateUnion(NSRange range1, NSRange range2, NSUIntegerEnumerationBlock enumerationBlock)
{
	NSRange firstDelta;
	NSRange intersectionRange = NSIntersectionRange(range1, range2);
	NSRange secondDelta;
	
	if (intersectionRange.length)
	{
		firstDelta = NSRangeFromValues(range1.location, range2.location);
		secondDelta = NSRangeFromValues(NSMaxRange(range1), NSMaxRange(range2));
	}
	else
	{
		firstDelta = range1;
		secondDelta = range2;
	}
	
	NSRangeEnumerate(firstDelta, enumerationBlock);
	NSRangeEnumerate(intersectionRange, enumerationBlock);
	NSRangeEnumerate(secondDelta, enumerationBlock);
	
};