//
//  BRModelObjectPrimitives.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>

typedef NSInteger BRTimeInterval;

typedef NS_ENUM(BRTimeInterval, BRShiftType)
{
    BRShiftTypeNoBreaks                   = 0,
    BRShiftTypeOneBreak                   = 900,
    BRShiftTypeTwoBreaks                  = 1800,
    BRShiftTypeOneBreakAndOneHalfLunch    = 2700,
    BRShiftTypeTwoBreaksAndOneFullLunch   = 5400
};

typedef NS_ENUM(BRTimeInterval, BRBreakType)
{
    BRBreakTypeFifteen    = 900,
    BRBreakTypeHalfLunch  = 1800,
    BRBreakTypeFullLunch  = 3600
};