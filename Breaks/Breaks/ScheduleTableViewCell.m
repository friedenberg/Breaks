//
//  ScheduleTableViewCell.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleTableViewCell.h"

#import "ScheduleView.h"


@implementation ScheduleViewShiftCell

- (id)initWithTable:(ScheduleView *)someTable reuseIdentifier:(NSString *)identifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) 
	{
        superTable = someTable;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundColor = [UIColor clearColor];
		self.backgroundView = nil;

		employeeHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
		employeeHeaderView.backgroundColor = [UIColor darkGrayColor];
        employeeNameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        
		employeeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		employeeNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		employeeNameLabel.font = [UIFont boldSystemFontOfSize:16];
		employeeNameLabel.backgroundColor = [UIColor lightGrayColor];
		[employeeHeaderView addSubview:employeeNameLabel];
		[self.contentView addSubview:employeeHeaderView];
        
        scheduleBlockView = [[UIView alloc] initWithFrame:CGRectZero];
        scheduleBlockView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:scheduleBlockView];
        [self.contentView bringSubviewToFront:employeeHeaderView];
    }
	
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	CGFloat headerWidth = superTable.employeeHeaderWidth;
	CGFloat increment = superTable.hourWidth;
	
	CGRect employeeHeaderFrame = bounds;
	employeeHeaderFrame.size.width = headerWidth;
	employeeHeaderFrame.size.height = bounds.size.height;
	employeeHeaderFrame.origin.y = 0;
	employeeHeaderView.frame = employeeHeaderFrame;
    
    CGRect scheduleFrame = bounds;
    CGFloat start = ((CGFloat)shiftStart - 700) / 100;
    CGFloat end = ((CGFloat)shiftEnd - 700) / 100;
    scheduleFrame.origin.x = floor(start * increment + headerWidth);
    scheduleFrame.size.width = floor(end * increment + headerWidth) - scheduleFrame.origin.x;
    scheduleBlockView.frame = scheduleFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize employeeNameLabel, shiftStart, shiftEnd;

- (void)setShiftStart:(NSUInteger)value
{
    shiftStart = value;
    [self setNeedsLayout];
}

- (void)setShiftEnd:(NSUInteger)value
{
    shiftEnd = value;
    [self setNeedsLayout];
}

- (void)setEmployeeHeaderViewXContentOffset:(CGFloat)offset
{
	CGRect frame = employeeHeaderView.frame;
	frame.origin.x = offset;
	employeeHeaderView.frame = frame;
}

- (void)dealloc
{
    [scheduleBlockView release];
	[employeeNameLabel release];
	[employeeHeaderView release];
	[super dealloc];
}

@end
