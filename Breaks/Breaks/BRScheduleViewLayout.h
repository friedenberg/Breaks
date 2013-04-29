//
//  BRScheduleViewLayout.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import <UIKit/UIKit.h>


@class BRScheduleView;

@interface BRScheduleViewLayout : UICollectionViewLayout

- (instancetype)initWithScheduleView:(BRScheduleView *)someScheduleView;

@property (nonatomic, weak) BRScheduleView *scheduleView;
@property (nonatomic, strong) NSString *keyPathForScheduleDurations;

@end
