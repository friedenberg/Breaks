//
//  BRScheduleView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleView.h"

#import "BRScheduleView_PrivateLayoutAdditions.h"
#import "BRScheduleDuration.h"

#import "BRScheduleViewZoningLayout.h"

#import "NSDate+ScheduleViewDateAdditions.h"



@interface BRScheduleView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_headerCollectionView;
    UICollectionView *_zoningCollectionView;
    UICollectionView *_breakCollectionView;
    
    //cache
	NSMutableArray *_zoningDurations; //array of arrays of durations
	NSMutableArray *_breakDurations; //array of arrays of durations
    
    //timehead
    UIImageView *_timeheadView;
	CGFloat _timeheadProgress;
    
    //zoning colors
    NSMutableDictionary *_zoningViewTintedImages;
    
    //flags
    struct
	{
		unsigned int headerTitles:1;
		unsigned int hexColors:1;
		unsigned int headerAccessoryImages:1;
		unsigned int breakImages:1;
		
		unsigned int didSelectZoningView:1;
		unsigned int didSelectBreakView:1;
		
	} delegateResponseFlags;
}

@end

@implementation BRScheduleView

static UIImage *kTimeheadCarotImage;

+ (void)initialize
{
    if (self == [BRScheduleView class]) {
        kTimeheadCarotImage = [[UIImage imageNamed:@"timeheadCarot"] resizableImageWithCapInsets:UIEdgeInsetsMake(31, 0, 0, 0)];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _referenceDate = [NSDate today];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        _rulerHeight = 40;
        _rowHeight = 44;
        _hourWidth = 100;
        _hoursVisibleRange = NSMakeRange(7, 20);
        _headerWidth = 200;
        
		_zoningDurations = [NSMutableArray new];
		_breakDurations = [NSMutableArray new];
        
        BRScheduleViewZoningLayout *zoningLayout = [[BRScheduleViewZoningLayout alloc] initWithScheduleView:self];
        _zoningCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:zoningLayout];
        _zoningCollectionView.dataSource = self;
        _zoningCollectionView.delegate = self;
    }
    
    return self;
}

#pragma mark - Geometry

- (CGSize)contentSize
{
    CGSize size = CGSizeZero;
    size.width = _headerWidth + _hoursVisibleRange.length * _hourWidth;
    size.height = _rulerHeight + _zoningDurations.count * _rowHeight;
    return size;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _zoningCollectionView) {
        return _zoningDurations.count;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _zoningCollectionView) {
        return [_zoningDurations[section] count];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDelegate

@end
