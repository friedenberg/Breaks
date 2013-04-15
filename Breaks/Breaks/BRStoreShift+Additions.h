//
//  BRStoreShift+Additions.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRShift.h"
#import "BRModelObjectPrimitives.h"


@interface BRShift (Additions)

@property (nonatomic, readonly) BRShiftType shiftType;

- (void)standardizeBreaks;

@end
