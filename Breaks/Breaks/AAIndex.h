//
//  AAUnsignedIntegerDictionary.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/16/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAIndex : NSObject
{
    NSUInteger count;
    NSUInteger *indices;
    
    NSMutableArray *objects;
}

- (void)setIndex:(NSUInteger)someIndex forObject:(id)someObject;
- (void)removeObjectForIndex:(NSUInteger)someIndex;
- (id)objectForIndex:(NSUInteger)someIndex;

- (id)pullRecycledObject;

@end
