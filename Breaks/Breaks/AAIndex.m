//
//  AAUnsignedIntegerDictionary.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/16/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AAIndex.h"

@interface AAIndex ()

- (void)resizeIndices;
- (NSInteger)internalIndexForIndex:(NSUInteger)someIndex;

@end


@implementation AAIndex

- (id)init
{
    if (self = [super init])
    {
        count = 0;
        objects = [NSMutableArray new];
    }
    
    return self;
}

- (void)resizeIndices
{
    void *pointer = realloc(indices, sizeof(NSUInteger) * count);
    if (!pointer) @throw [NSException exceptionWithName:NSGenericException reason:@"Cannot allocate memory" userInfo:nil];
    else indices = pointer;
}

- (NSInteger)internalIndexForIndex:(NSUInteger)someIndex
{
    NSInteger index = -1;
    
    for (int i = 0; i < count; i++)
    {
        if (indices[i] == someIndex)
        {
            index = i;
            break;
        }
    }
    
    return index;
}

- (void)setIndex:(NSUInteger)someIndex forObject:(id)someObject
{
    NSInteger foundIndex = [self internalIndexForIndex:someIndex];
    
    if (foundIndex == -1)
    {
        count++;
        [self resizeIndices];
    }
    
    NSUInteger insertedIndex = foundIndex >= 0 ? foundIndex : count - 1;
    
    indices[insertedIndex] = someIndex;
    [objects addObject:someObject];
}

- (void)removeObjectForIndex:(NSUInteger)someIndex
{
    NSInteger index = [self internalIndexForIndex:someIndex];
    
   if (index >= 0)
   {
       [objects removeObjectAtIndex:index];
       
       for (int i = index + 1; i < count; i++) indices[i - 1] = indices[i];
       
       count--;
       [self resizeIndices];
   }
}

- (id)objectForIndex:(NSUInteger)someIndex
{
    id object = nil;
    
    NSInteger index = [self internalIndexForIndex:someIndex];
    if (index >= 0) object = [objects objectAtIndex:index];
    
    return object;
}

- (id)pullRecycledObject
{
	id object = [objects lastObject];
	
	if (count && objects.count)
	{
		count--;
		[self resizeIndices];
	}
	
	return object;
}

- (void)dealloc
{
    free(indices);
    [objects release];
    [super dealloc];
}

@end
