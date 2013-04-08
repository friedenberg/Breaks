//
//  ScheduleBackgroundView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduleViewBackgroundView : UIView
{
	CGFloat rulerHeight;
    NSRange hoursVisibleRange;
}

@property (nonatomic) CGFloat rulerHeight;
@property (nonatomic) NSRange hoursVisibleRange;

@property (nonatomic) BOOL showsRuler;

@end