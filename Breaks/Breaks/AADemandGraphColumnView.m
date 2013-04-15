//
//  AADemandGraphColumnView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/19/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AADemandGraphColumnView.h"


@implementation AADemandGraphColumnView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
		backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
		backgroundView.backgroundColor = [UIColor orangeColor];
		[self addSubview:backgroundView];
		
        controlPointView = [[UIView alloc] initWithFrame:CGRectZero];
		controlPointView.backgroundColor = [UIColor blueColor];
		[self addSubview:controlPointView];
    }
	
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;

	static CGFloat controlPointWidth = 10;
	
	backgroundView.frame = CGRectInsetFromTop(bounds, controlPointWidth / 2);
	
	CGRect controlPointFrame = bounds;
	controlPointFrame.size = CGSizeMake(controlPointWidth, controlPointWidth);
	controlPointFrame.origin.x = floor(CGRectGetMidX(bounds) - controlPointWidth / 2);
	
	controlPointView.frame = controlPointFrame;
}

@synthesize editing;
@synthesize selected;

@synthesize controlPointView;


@end
