//
//  ScheduleTableViewCell.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleView;

@interface ScheduleViewShiftCell : UITableViewCell
{
    ScheduleView *superTable;
    
	UIView *employeeHeaderView;
	UILabel *employeeNameLabel;
    UIView *scheduleBlockView;
    
    NSUInteger shiftStart;
    NSUInteger shiftEnd;
}

- (id)initWithTable:(ScheduleView *)someTable reuseIdentifier:(NSString *)identifier;

@property (nonatomic, readonly) UILabel *employeeNameLabel;

@property (nonatomic) NSUInteger shiftStart;
@property (nonatomic) NSUInteger shiftEnd;

@end
