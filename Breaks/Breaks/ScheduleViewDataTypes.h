//
//  ScheduleViewDataTypes.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct _AADuration 
{
    CGFloat start;
    CGFloat length;
	
} AADuration;

extern const AADuration AADurationZero;
extern AADuration AADurationMake(CGFloat start, CGFloat length);
extern AADuration AADurationFromNSRange(NSRange range);

extern BOOL AADurationsEqual(AADuration a, AADuration b);
extern CGFloat AADurationMax(AADuration duration);
extern BOOL AADurationContainsValue(AADuration duration, CGFloat value);
extern BOOL AADurationsOverlap(AADuration outerDuration, AADuration innerDuration);

extern NSString *NSStringFromAADuration(AADuration duration);

@protocol ScheduleViewObject <NSObject>

@property (nonatomic, readonly) NSDate *start;
@property (nonatomic, readonly) NSDate *end;

@end