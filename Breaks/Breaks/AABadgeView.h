//
//  AABadgeView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/29/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef enum
{
	AABadgeViewStateEmpty,
	AABadgeViewStateHighlighted,
	AABadgeViewStateSelected
	
} AABadgeViewState;

@interface AABadgeView : UIView
{
	AABadgeViewState state;
	UIImageView *imageView;
}

@property (nonatomic) AABadgeViewState state;

@end
