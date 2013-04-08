//
//  ScheduleViewEmployeeHeader.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/10/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewSubview.h"

@interface ScheduleViewEmployeeHeader : ScheduleViewSubview
{
	UILabel *nameLabel;
}

@property (nonatomic, readonly) UILabel *nameLabel;

@end
