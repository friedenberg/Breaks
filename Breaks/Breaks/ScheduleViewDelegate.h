//
//  ScheduleViewDelegate.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleView;

@protocol ScheduleViewDelegate <UIScrollViewDelegate>

@optional;

- (NSString *)headerTitleAtIndexPath:(NSIndexPath *)indexPath			inScheduleView:(ScheduleView *)someScheduleView;
- (NSString *)hexColorForZoningAtIndexPath:(NSIndexPath *)indexPath		inScheduleView:(ScheduleView *)someScheduleView;
- (UIImage *)imageForHeaderAccessoryAtIndex:(NSIndexPath *)indexPath	inScheduleView:(ScheduleView *)someScheduleView;
- (UIImage *)imageForBreakAtIndexPath:(NSIndexPath *)indexPath			inScheduleView:(ScheduleView *)someScheduleView;

- (void)scheduleView:(ScheduleView *)someScheduleView didSelectZoningViewAtIndexPath:(NSIndexPath *)indexPath;
- (void)scheduleView:(ScheduleView *)someScheduleView didSelectBreakViewAtIndexPath:(NSIndexPath *)indexPath;

@end
