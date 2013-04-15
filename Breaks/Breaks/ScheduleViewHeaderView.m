//
//  ScheduleViewEmployeeHeader.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/10/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewHeaderView.h"

@implementation ScheduleViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.shouldShowSelectionControlDuringEditing = YES;
		
		separatorView = [[UIView alloc] initWithFrame:CGRectZero];
		separatorView.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:separatorView];
		
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		nameLabel.textColor = [UIColor blackColor];
		[self.contentView addSubview:nameLabel];
		
		imageView = [[UIImageView alloc] initWithImage:nil];
		[self.contentView addSubview:imageView];
		
		self.backgroundColor = [UIColor whiteColor];
	}
	
	return self;
}

@synthesize nameLabel;

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.contentView.bounds;
	
	CGRect separatorRect = self.bounds;
	separatorRect.size.height = 1;
	separatorView.frame = separatorRect;
	
	static CGFloat contentPadding = 4;
	
	[nameLabel sizeToFit];
	[imageView sizeToFit];
	CGRect labelFrame = nameLabel.frame;
	CGRect imageRect = imageView.frame;
	
	labelFrame.origin.x = contentPadding;
	labelFrame.size.width = bounds.size.width - contentPadding;
	labelFrame.origin.y = floor(CGRectGetMidY(bounds) - labelFrame.size.height / 2);
	
	if (imageView.image)
	{
		imageRect.origin.x = bounds.size.width - (imageRect.size.width + contentPadding);
		imageRect.origin.y = floor(CGRectGetMidY(bounds) - imageRect.size.height / 2);
		labelFrame.size.width -= imageRect.size.width + contentPadding;
	}
	
	imageView.frame = imageRect;
	nameLabel.frame = labelFrame;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
	[nameLabel setBackgroundColor:backgroundColor];
}

- (void)dealloc
{
	[separatorView release];
	[imageView release];
	[nameLabel release];
	[super dealloc];
}

@end
