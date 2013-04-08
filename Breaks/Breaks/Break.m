//
//  Break.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/23/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "Break.h"
#import "Shift.h"


NSInteger kBreakTimeTakenEnded = -2;
NSInteger kBreakTimeTakenHasNotStarted = -1;

@implementation Break

@dynamic type;
@dynamic shift;
@dynamic timeTaken;

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	[self setPrimitiveValue:[NSDate distantFuture] forKey:@"timeTaken"];
}

- (NSString *)sectionTitle
{
	if ([self.timeTaken isEqualToDate:[NSDate distantFuture]] && [self.start isLaterThanDate:[NSDate date]]) return @"Future";
	else if ([self.timeTaken isEqualToDate:[NSDate distantFuture]]) return @"Late";
	else return @"Started";
}

- (void)startBreak
{
	self.timeTaken = [NSDate date];
	self.start = [NSDate date];
	self.end = [self.start dateByAddingTimeInterval:self.type];
}

- (void)endBreak
{
	self.timeTaken = nil;
}

@end
