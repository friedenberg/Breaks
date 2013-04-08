//
//  Break.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/23/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduledObject.h"


typedef enum 
{
    BreakTypeFifteen    = 900,
    BreakTypeHalfLunch  = 1800,
    BreakTypeFullLunch  = 3600
    
} BreakType;

@class Shift;

@interface Break : ScheduledObject

@property (nonatomic) int16_t type;
@property (nonatomic, retain) Shift *shift;
@property (nonatomic, retain) NSDate *timeTaken; //value is [NSDate distantFuture] if the break has yet to be started. If the break has ended, the value is nil
@property (nonatomic, readonly) NSString *sectionTitle;

- (void)startBreak;
- (void)endBreak;

@end
