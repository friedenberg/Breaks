//
//  ScheduleViewBreakView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/24/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewBreakView.h"

@implementation ScheduleViewBreakView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
        self.backgroundColor = [UIColor orangeColor];
    }
	
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.contentView.bounds;
	
	[self.imageView sizeToFit];
	CGRect imageFrame = self.imageView.frame;
	imageFrame.origin.x = floor(CGRectGetMidX(bounds) - imageFrame.size.width / 2);
	imageFrame.origin.y = floor(CGRectGetMidY(bounds) - imageFrame.size.height / 2);
	self.imageView.frame = imageFrame;
	
	self.alpha = !self.editing;
}

- (void)setSelected:(BOOL)value
{
	
}

@end
