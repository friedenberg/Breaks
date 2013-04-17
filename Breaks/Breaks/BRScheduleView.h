//
//  BRScheduleView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import <UIKit/UIKit.h>
#import <AAKit/AAKit.h>


@class BRScheduleView, BRScheduleDuration;

@protocol BRScheduleViewDataSource <NSObject>

- (NSUInteger)numberOfShiftsInScheduleView:(BRScheduleView *)someScheduleView;
- (NSUInteger)numberOfZoningsInShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView;
- (NSUInteger)numberOfBreaksInShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView;

- (BRScheduleDuration *)zoningDurationForZoning:(NSUInteger)zoningIndex forShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView;
- (BRScheduleDuration *)breakDurationForBreak:(NSUInteger)breakIndex forShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView;

@end


@protocol BRScheduleViewDelegate <NSObject>



@end


@interface BRScheduleView : UIView

@property (nonatomic, weak) IBOutlet id <BRScheduleViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <BRScheduleViewDelegate> delegate;

@property (nonatomic, copy) NSDate *referenceDate;

//geometry
@property (nonatomic) CGFloat rulerHeight;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat hourWidth;
@property (nonatomic) NSRange hoursVisibleRange;
@property (nonatomic) CGFloat headerWidth;
@property (nonatomic, readonly) CGSize scheduleContentSize;
@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic) CGPoint contentOffset;

- (void)reloadSchedule;

@end
