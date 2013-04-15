//
//  AABadgeView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/29/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AABadgeView.h"

@implementation AABadgeView

static CGSize badgeShadowOffsetSize = {0, 1.25};
static float badgeShadowOpacity = 0.7;
static float badgeShadowRadius = 1.5;

static UIImage *badgeImagePlaceholder;
static UIImage *badgeImageActive;
static UIImage *badgeImagePassive;

+ (void)initialize
{
	if (self == [AABadgeView class])
	{
		badgeImagePlaceholder = [UIImage imageNamed:@"Checkmark Placeholder.png"];
		badgeImageActive = [UIImage imageNamed:@"Active Checkmark.png"];
		badgeImagePassive = [UIImage imageNamed:@"Inactive Checkmark.png"];
	}
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.backgroundColor = [UIColor clearColor];
		imageView = [[UIImageView alloc] initWithFrame:frame];
		[self addSubview:imageView];
		
		CALayer *layer = imageView.layer;
		
        layer.shadowOffset = badgeShadowOffsetSize;
		layer.shadowOpacity = badgeShadowOpacity;
		layer.shadowRadius = badgeShadowRadius;
		
		self.state = AABadgeViewStateEmpty;
    }
	
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return CGSizeMake(23, 23);
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
	imageView.frame = bounds;
}

- (void)drawRect:(CGRect)rect
{
	[badgeImagePlaceholder drawInRect:self.bounds];
}

@synthesize state;

- (void)setState:(AABadgeViewState)value
{
	state = value;
	
	switch (state)
	{
		case AABadgeViewStateEmpty:
			imageView.image = nil;
			break;
			
		case AABadgeViewStateHighlighted:
			imageView.image = badgeImageActive;
			break;
			
		case AABadgeViewStateSelected:
			imageView.image = badgeImagePassive;
			break;
			
		default:
			break;
	}
}

@end
