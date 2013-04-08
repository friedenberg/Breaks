//
//  ScheduleViewCell.m
//  
//
//  Created by Sasha Friedenberg on 4/29/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewCell.h"

#import "AABadgeView.h"


@implementation ScheduleViewCell

static UIColor *selectedColor;

+ (void)initialize
{
	if (self == [ScheduleViewCell class])
	{
		selectedColor = [[UIColor colorWithRed:0.892 green:0.924 blue:0.977 alpha:1.000] retain];
	}
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		badgeView = [[AABadgeView alloc] initWithFrame:CGRectZero];
		[badgeView sizeToFit];
		[self addSubview:badgeView];
		
		contentView = [[UIView alloc] initWithFrame:CGRectZero];
		contentView.backgroundColor = [UIColor clearColor];
		[self addSubview:contentView];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:imageView];
	}
	
	return self;
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
	CGRect contentFrame = bounds;
	CGRect badgeFrame = badgeView.frame;
	
	CGFloat badgeViewMargin = (bounds.size.height - badgeFrame.size.height) / 2;
	badgeViewMargin = floor(badgeViewMargin);
	badgeFrame.origin.y = badgeViewMargin;
	
	badgeFrame.origin.x = editing && shouldShowSelectionControlDuringEditing ? badgeViewMargin : -(badgeFrame.size.width + badgeViewMargin);
	
	contentFrame.origin.x = CGRectGetMaxX(badgeFrame) + badgeViewMargin;
	contentFrame.size.width -= CGRectGetMinX(contentFrame);
	
	contentView.frame = contentFrame;
	badgeView.frame = badgeFrame;
	
	badgeView.alpha = editing;
}

@synthesize contentView, imageView, editing, selected;

- (void)setEditing:(BOOL)value
{
	[self setEditing:value animated:NO];
}

- (void)setHighlighted
{
	badgeView.state = AABadgeViewStateHighlighted;
	self.backgroundColor = selectedColor;
}

- (void)setSelected:(BOOL)value
{
	[self setSelected:value animated:NO];
}

- (void)setSelected:(BOOL)value animated:(BOOL)animated
{
	selected = value;
	
	if (selected)
	{
		badgeView.state = AABadgeViewStateSelected;
		self.backgroundColor = selectedColor;
	}
	else 
	{
		badgeView.state = AABadgeViewStateEmpty;
		self.backgroundColor = [UIColor whiteColor];
	}
}

- (void)layoutSubviewsAnimated:(BOOL)animated
{
	if (animated)
	{
		[UIView animateWithDuration:0.35 animations:^{
			
			[self layoutSubviews];
			
		}];
	}
	else [self setNeedsLayout];
}

- (void)setEditing:(BOOL)value animated:(BOOL)animated
{
	[self layoutSubviewsAnimated:NO];
	editing = value;
	[self layoutSubviewsAnimated:animated];
}

@synthesize shouldShowSelectionControlDuringEditing;

- (void)dealloc
{
	[badgeView release];
	[imageView release];
	[contentView release];
	[super dealloc];
}


@end
