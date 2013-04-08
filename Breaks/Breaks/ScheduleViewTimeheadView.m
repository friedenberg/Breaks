//
//  ScheduleViewTimeheadView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/26/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewTimeheadView.h"


const CGFloat kScheduleViewTimeheadViewStandardWidth = 10;

@implementation ScheduleViewTimeheadView

static UIImage *kCarotImage;

+ (void)initialize
{
	if (self == [ScheduleViewTimeheadView class])
	{
		CGRect bounds = CGRectMake(0, 0, 10, 14);
		
		UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
		//CGContextRef context = UIGraphicsGetCurrentContext();
		
		[[UIColor redColor] set];
		UIBezierPath *headPath = [UIBezierPath bezierPath];
		[headPath moveToPoint:CGPointZero];
		[headPath addLineToPoint:CGPointMake(5, 14)];
		[headPath addLineToPoint:CGPointMake(10, 0)];
		[headPath closePath];
		[headPath fill];
		
		kCarotImage = [UIGraphicsGetImageFromCurrentImageContext() retain];
		
		UIGraphicsEndImageContext();
	}
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		barView = [[UIView alloc] initWithFrame:CGRectZero];
		barView.backgroundColor = [UIColor blackColor];
		carotView = [[UIImageView alloc] initWithImage:kCarotImage];
		
		[self addSubview:barView];
		[self addSubview:carotView];
		
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	
	CGRect lineFrame = bounds;
	lineFrame.size.width = 2;
	lineFrame.origin.x = floor(CGRectGetMidX(bounds) - 1);
	barView.frame = lineFrame;
	
	CGRect imageViewFrame = CGRectZero;
	imageViewFrame.size = carotView.image.size;
	carotView.frame = imageViewFrame;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	size.width = carotView.image.size.width;
	size.height = MAX(size.height, carotView.image.size.height);
	return size;
}

- (void)dealloc
{
	[carotView release];
	[barView release];
	[super dealloc];
}

@end
