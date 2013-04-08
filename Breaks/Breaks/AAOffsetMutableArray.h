//
//  AAOffsetMutableArray.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/11/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAOffsetMutableArray : NSMutableArray
{
	NSMutableArray *array;
	NSUInteger offset;
}

@property (nonatomic) NSUInteger offset;

- (id)objectAtOffsetIndex:(NSUInteger)index;
- (void)insertObject:(id)anObject atOffsetIndex:(NSUInteger)index;
- (void)removeObjectAtOffsetIndex:(NSUInteger)index;
- (void)replaceObjectAtOffsetIndex:(NSUInteger)index withObject:(id)anObject;

@end
