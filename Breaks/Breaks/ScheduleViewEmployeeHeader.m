//
//  ScheduleViewEmployeeHeader.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/10/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewEmployeeHeader.h"

@implementation ScheduleViewEmployeeHeader

- (id)initWithScheduleView:(ScheduleView *)someSchedule
{
	if (self = [super initWithScheduleView:someSchedule])
	{
		self.clipsToBounds = NO;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		nameLabel.textColor = [UIColor whiteColor];
		nameLabel.backgroundColor = [UIColor grayColor];
		[self addSubview:nameLabel];
	}
	
	return self;
}

//- (void)setFrame:(CGRect)value
//{
//	[super setFrame:value];
//	if (value.size.width == 0) nameLabel.backgroundColor = [UIColor clearColor];
//	else nameLabel.backgroundColor = [UIColor grayColor];
//}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[nameLabel sizeToFit];
	CGRect nameFrame = nameLabel.frame;
	nameFrame.size.height = self.bounds.size.height;
	nameLabel.frame = nameFrame;
}

@synthesize nameLabel;

- (void)dealloc
{
	[nameLabel release];
	[super dealloc];
}

@end
