//
//  BRScheduleView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleView.h"

#import "BRScheduleCaptureView.h"

#import "BRScheduleView_PrivateLayoutAdditions.h"
#import "BRScheduleBackgroundView.h"
#import "BRScheduleDuration.h"

#import "BRScheduleViewZoningLayout.h"

#import "NSDate+ScheduleViewDateAdditions.h"



@interface BRScheduleView () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    BRScheduleCaptureView *_captureView;
    
    UICollectionView *_headerCollectionView;
    UICollectionView *_zoningCollectionView;
    UICollectionView *_breakCollectionView;
    
    UIScrollView *_backgroundScrollView;
    BRScheduleBackgroundView *_backgroundView;
    
    //cache
	NSMutableArray *_zoningDurations; //array of arrays of durations
	NSMutableArray *_breakDurations; //array of arrays of durations
    
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

- (void)updateContentSize;
- (void)updateContentOffsets;

@end

@implementation BRScheduleView

static NSString *kZoningCell = @"kZoningCell";
static UIImage *kTimeheadCarotImage;

+ (void)initialize
{
    if (self == [BRScheduleView class]) {
        kTimeheadCarotImage = [[UIImage imageNamed:@"timeheadCarot"] resizableImageWithCapInsets:UIEdgeInsetsMake(31, 0, 0, 0)];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
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
        _zoningCollectionView.backgroundColor = [UIColor clearColor];
        [_zoningCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kZoningCell];
        _zoningCollectionView.dataSource = self;
        _zoningCollectionView.delegate = self;
        
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        _backgroundView = [[BRScheduleBackgroundView alloc] initWithFrame:CGRectZero];
        _backgroundView.scheduleView = self;
        [_backgroundScrollView addSubview:_backgroundView];
        
        _captureView = [[BRScheduleCaptureView alloc] initWithFrame:CGRectZero];
        _captureView.scheduleView = self;
        _captureView.delegate = self;
        
        [self addSubview:_backgroundScrollView];
        [self addSubview:_zoningCollectionView];
        
        [self addSubview:_captureView];
    }
    
    return self;
}

#pragma mark - Geometry

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGPoint contentOffset = _captureView.contentOffset;
    
    _captureView.frame = bounds;
    
    //zoning collection view frame
    _zoningCollectionView.frame = bounds;
    _backgroundScrollView.frame = bounds;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
	insets.top = _rulerHeight;
	insets.left = _headerWidth;
	
    _captureView.contentInset = insets;
    _zoningCollectionView.contentInset = insets;
    
    //backgroundview positioning
    CGRect backgroundFrame = bounds;
    backgroundFrame.origin.y = _rulerHeight;
    backgroundFrame.size.width = _scheduleContentSize.width;
    _backgroundView.frame = backgroundFrame;
}

#pragma mark - UIView

- (void)didMoveToSuperview
{
    [self reloadSchedule];
}

#pragma mark - BRScheduleView

- (void)updateContentSize
{
    [self willChangeValueForKey:@"scheduleContentSize"];
    _scheduleContentSize = CGSizeZero;
    _scheduleContentSize.width = _hoursVisibleRange.length * _hourWidth;
    _scheduleContentSize.height = _zoningDurations.count * _rowHeight;
    [self didChangeValueForKey:@"scheduleContentSize"];
    
    [self willChangeValueForKey:@"contentSize"];
    _contentSize = _scheduleContentSize;
    _contentSize.width = _headerWidth;
    _contentSize.height = _rulerHeight;
    [self didChangeValueForKey:@"contentSize"];
    
    _captureView.contentSize = _scheduleContentSize;
    _backgroundScrollView.contentSize = CGSizeMake(_contentSize.width, CGRectGetMaxY(self.bounds));
}

- (void)updateContentOffsets
{
    CGPoint contentOffset = _captureView.contentOffset;
    _zoningCollectionView.contentOffset = contentOffset;
    _backgroundScrollView.contentOffset = CGPointMake(contentOffset.x, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _captureView) {
        [self updateContentOffsets];
    }
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZoningCell forIndexPath:indexPath];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PAA_dBIndicators_Mixer_01"]];
    cell.backgroundView = backgroundView;
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - BRScheduleView

- (void)reloadSchedule
{
    NSUInteger shiftCount = [self.dataSource numberOfShiftsInScheduleView:self];
    [_zoningDurations removeAllObjects];
    [_breakDurations removeAllObjects];
    
    NSUIntegerEnumerate(shiftCount, ^(NSUInteger shiftIndex) {
        
        NSUInteger zoningCount = [self.dataSource numberOfZoningsInShift:shiftIndex inScheduleView:self];
        NSUInteger breakCount = [self.dataSource numberOfBreaksInShift:shiftIndex inScheduleView:self];
        
        NSMutableArray *zonings = [NSMutableArray arrayWithCapacity:zoningCount];
        NSMutableArray *breaks = [NSMutableArray arrayWithCapacity:breakCount];
        
        [_zoningDurations addObject:zonings];
        [_breakDurations addObject:breaks];
        
        NSUIntegerEnumerate(zoningCount, ^(NSUInteger zoningIndex) {
            
            [zonings addObject:[self.dataSource zoningDurationForZoning:zoningIndex forShift:shiftIndex inScheduleView:self]];
            
        });
        
        NSUIntegerEnumerate(breakCount, ^(NSUInteger breakIndex) {
            
            [breaks addObject:[self.dataSource breakDurationForBreak:breakIndex forShift:shiftIndex inScheduleView:self]];
            
        });
        
    });
    
    [self updateContentSize];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _captureView.contentOffset = CGPointMake(-_headerWidth, -_rulerHeight);
}

@end
