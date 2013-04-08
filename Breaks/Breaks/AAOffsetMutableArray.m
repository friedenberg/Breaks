//
//  AAOffsetMutableArray.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/11/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AAOffsetMutableArray.h"

@implementation AAOffsetMutableArray

- (id)init
{
	if (self = [super init])
	{
		array = [NSMutableArray new];
	}
	
	return self;
}

- (NSUInteger)count
{
	return [array count];
}

- (id)objectAtIndex:(NSUInteger)index
{
	return [array objectAtIndex:index];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
	[array insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
	[array removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject
{
	[array addObject:anObject];
}

- (void)removeLastObject
{
	[array removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
	[array replaceObjectAtIndex:index withObject:anObject];
}

@synthesize offset;

- (id)objectAtOffsetIndex:(NSUInteger)index
{
	return [self objectAtIndex:index + offset];
}

- (void)insertObject:(id)anObject atOffsetIndex:(NSUInteger)index
{
	[self insertObject:anObject atIndex:index + offset];
}

- (void)removeObjectAtOffsetIndex:(NSUInteger)index
{
	[self removeObjectAtIndex:index + offset];
}

- (void)replaceObjectAtOffsetIndex:(NSUInteger)index withObject:(id)anObject
{
	[self replaceObjectAtIndex:index + offset withObject:anObject];
}

- (void)dealloc
{
	[array release];
	[super dealloc];
}

@end
