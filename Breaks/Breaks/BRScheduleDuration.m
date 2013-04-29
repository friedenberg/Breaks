//
//  BRScheduleDuration.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleDuration.h"

@implementation BRScheduleDuration

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@ — %@)", super.description, _startDate.description, _endDate.description];
}

@end
