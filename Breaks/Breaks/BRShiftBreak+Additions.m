//
//  BRShiftBreak+Additions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRShiftBreak+Additions.h"

#import "BRDuration.h"


@implementation BRBreak (Additions)

+ (NSArray *)shiftBreaksWithDurations:(NSArray *)durations managedObjectContext:(NSManagedObjectContext *)someContext
{
    NSMutableArray *shiftBreaks = [NSMutableArray arrayWithCapacity:durations.count];
    
    for (NSNumber *duration in durations) {
        BRBreak *shiftBreak = [NSEntityDescription insertNewObjectForEntityForName:@"BRBreak" inManagedObjectContext:someContext];
        shiftBreak.type = duration.integerValue;
        [shiftBreaks addObject:shiftBreak];
    }
    
    return shiftBreaks.copy;
}

@end
