//
//  ScheduleTableViewCell.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewZoningView.h"


@implementation ScheduleViewZoningView

static CGFloat cornerRadius = 15;
static UIImage *backgroundImage;

+ (void)initialize
{
	if (self == [ScheduleViewZoningView class])
	{
		CGRect bounds = CGRectMake(0, 0, 100, 44);
		
		UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
		//CGContextRef context = UIGraphicsGetCurrentContext();
		
		[[UIColor whiteColor] set];
		[[UIColor colorWithWhite:0.1 alpha:1] setStroke];
		
		UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius - 1];
		[roundedRect fill];
		[roundedRect stroke];
		
		backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
		backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
		
		UIGraphicsEndImageContext();
	}
}

+ (UIImage *)defaultBackgroundImage
{
	return backgroundImage;
}

+ (UIImage *)backgroundImageWithFillColor:(UIColor *)color
{
	CGRect bounds = CGRectMake(0, 0, 100, 44);
	
	UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.0);
	//CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor whiteColor] set];
	[[UIBezierPath bezierPathWithRect:bounds] fill];
	
	[color set];
	[[UIColor colorWithWhite:0.1 alpha:1] setStroke];
	
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius - 1];
	[roundedRect fill];
	//[roundedRect stroke];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
	
	UIGraphicsEndImageContext();
	
	return image;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) 
	{
		backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
		backgroundImageView.opaque = YES;
		[self addSubview:backgroundImageView];
		[self sendSubviewToBack:backgroundImageView];
		
		self.shouldShowSelectionControlDuringEditing = YES;
    }
	
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	backgroundImageView.frame = bounds;
}

@synthesize backgroundImageView;


@end
