//
//  BRScheduleBackgroundView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import <UIKit/UIKit.h>


@class BRScheduleView;

@interface BRScheduleBackgroundView : UIView

@property (nonatomic, weak) BRScheduleView *scheduleView;

@property (nonatomic) BOOL showsRuler;

@end
