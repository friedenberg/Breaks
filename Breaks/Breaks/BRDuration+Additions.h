//
//  BRDuration+Additions.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRDuration.h"


@class BRScheduleDuration;

@interface BRDuration (Additions)

- (BOOL)containsDate:(NSDate *)date;

@property (nonatomic, readonly) BRScheduleDuration *portableDuration;

@end
