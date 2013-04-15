//
//  BRScheduleViewLayout.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleViewLayout.h"

#import "BRScheduleView.h"


@implementation BRScheduleViewLayout

- (instancetype)initWithScheduleView:(BRScheduleView *)someScheduleView
{
    if (self = [super init]) {
        _scheduleView = someScheduleView;
        _layoutAttributes = [NSMutableArray new];
    }
    
    return self;
}

@end
