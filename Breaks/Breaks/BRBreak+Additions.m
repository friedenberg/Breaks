//
//  BRShiftBreak+Additions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRBreak+Additions.h"

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

- (NSString *)sectionTitle
{
    return @"Future";
    //if ([self.duration.actualStartDate isEqualToDate:[NSDate distantFuture]] && [self.duration.scheduledStartDate isLaterThanDate:[NSDate date]]) return @"Future";
    //else if ([self.duration.actualStartDate isEqualToDate:[NSDate distantFuture]]) return @"Late";
    //else return @"Started";
}

@end
