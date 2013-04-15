//
//  BRShiftBreak+Additions.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRBreak.h"

@interface BRBreak (Additions)

+ (NSArray *)shiftBreaksWithDurations:(NSArray *)durations managedObjectContext:(NSManagedObjectContext *)someContext;

@end
