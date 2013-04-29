//
//  BRScheduleContentView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleCaptureView.h"

#import "BRScheduleView.h"
#import "BRScheduleBackgroundView.h"

#import "BRScheduleView_Internal.h"


@interface BRScheduleCaptureView ()
{
    UIImageView *_timeheadView;
    CGFloat _timeheadProgress;
    
    BRScheduleBackgroundView *_rulerView;
}

@end

@implementation BRScheduleCaptureView

static UIImage *kTimeheadCarotImage;

+ (void)initialize
{
    if (self == [BRScheduleCaptureView class]) {
        kTimeheadCarotImage = [[UIImage imageNamed:@"timeheadCarot"] resizableImageWithCapInsets:UIEdgeInsetsMake(31, 0, 0, 0)];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = YES;
        
        _timeheadView = [[UIImageView alloc] initWithImage:kTimeheadCarotImage];
        _rulerView = [[BRScheduleBackgroundView alloc] initWithFrame:CGRectZero];
        _rulerView.showsRuler = YES;
        
        [self addSubview:_rulerView];
        [self addSubview:_timeheadView];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    _rulerView.scheduleView = _scheduleView;
    self.timeheadDisplayDate = [NSDate date];
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGRect visibleRect = bounds;
    visibleRect.origin = self.contentOffset;
    
    CGFloat rulerHeight = _scheduleView.rulerHeight;
    CGFloat headerWidth = _scheduleView.headerWidth;
    CGSize contentSize = self.contentSize;
    
    //ruler frame
    CGRect rulerFrame = CGRectZero;
    rulerFrame.origin.y = visibleRect.origin.y;
    rulerFrame.size.width = self.contentSize.width;
	rulerFrame.size.height = _scheduleView.rulerHeight;
	_rulerView.frame = rulerFrame;
	
    //scroller insets
	UIEdgeInsets insets = UIEdgeInsetsZero;
	insets.left = visibleRect.origin.x >= -headerWidth ? headerWidth : -visibleRect.origin.x;
	insets.top = rulerHeight;
	insets.right = MAX(CGRectGetMaxX(visibleRect) - contentSize.width, 0);
	self.scrollIndicatorInsets = insets;
	
	//timehead positioning
	CGRect timeheadFrame = bounds;
	timeheadFrame.size.width = kTimeheadCarotImage.size.width;
	timeheadFrame.origin.x = floor((contentSize.width * _timeheadProgress) - (kTimeheadCarotImage.size.width / 2));
	_timeheadView.frame = timeheadFrame;
}

#define BETWEEN(lower, value, upper) MAX(lower, MIN(upper, value))

- (void)setTimeheadDisplayDate:(NSDate *)value
{
	_timeheadDisplayDate = value;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:_timeheadDisplayDate];
	CGFloat currentAdjustedHour = (CGFloat)components.hour + ((CGFloat)components.minute / 60) - (CGFloat)_scheduleView.hoursVisibleRange.location;
	_timeheadProgress = currentAdjustedHour / (CGFloat)_scheduleView.hoursVisibleRange.length;
	_timeheadProgress = BETWEEN(0, _timeheadProgress, 1);
	
	[self setNeedsLayout];
}

@end
