//
//  NSRange+Convenience.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/25/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NSUIntegerEnumerationBlock)(NSUInteger index);

extern void NSUIntegerEnumerate(NSUInteger count, NSUIntegerEnumerationBlock enumerationBlock);

extern NSRange NSRangeFromValues(NSUInteger a, NSUInteger b);
extern void NSRangeEnumerate(NSRange range, NSUIntegerEnumerationBlock enumerationBlock);
extern void NSRangeEnumerateUnion(NSRange range1, NSRange range2, NSUIntegerEnumerationBlock enumerationBlock);