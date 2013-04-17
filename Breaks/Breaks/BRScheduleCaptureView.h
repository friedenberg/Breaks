//
//  BRScheduleContentView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import <UIKit/UIKit.h>


@class BRScheduleView;

@interface BRScheduleCaptureView : UIScrollView

@property (nonatomic, assign) BRScheduleView *scheduleView;
@property (nonatomic, strong) NSDate *timeheadDisplayDate;

@end
