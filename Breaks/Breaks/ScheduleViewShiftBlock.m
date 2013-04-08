//
//  ScheduleTableViewCell.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewShiftBlock.h"

#import "ScheduleView.h"


@implementation ScheduleViewShiftBlock

- (id)initWithScheduleView:(ScheduleView *)someSchedule
{
    if (self = [super initWithScheduleView:someSchedule]) 
	{
        self.backgroundColor = [UIColor redColor];
    }
	
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
