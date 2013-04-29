//
//  BRScheduleView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleView.h"

#import "BRTouchForwardingView.h"

#import "BRScheduleView_PrivateLayoutAdditions.h"
#import "BRScheduleBackgroundView.h"
#import "BRScheduleDuration.h"

#import "BRScheduleViewLayout.h"

#import "NSDate+ScheduleViewDateAdditions.h"

#import "BRScheduleView_Internal.h"


@interface BRScheduleView () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BRTouchForwardingView *_touchForwardingView;
    UIScrollView *_captureScrollView;
    
    UIView *_contentView;
    UITableView *_headerTableView;
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

@property (nonatomic, weak) UIView *firstResponder;

- (void)updateContentSize;
- (void)updateContentOffsets;
- (void)updateContentInsets;

@end

@implementation BRScheduleView

static NSString *kZoningCell = @"kZoningCell";
static NSString *kBreakCell = @"kBreakCell";
static NSString *kHeaderCell = @"kHeaderCell";
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
        
        BRScheduleViewLayout *zoningLayout = [[BRScheduleViewLayout alloc] initWithScheduleView:self];
        zoningLayout.keyPathForScheduleDurations = @"zoningDurations";
        _zoningCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:zoningLayout];
        _zoningCollectionView.backgroundColor = [UIColor clearColor];
        [_zoningCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kZoningCell];
        _zoningCollectionView.dataSource = self;
        _zoningCollectionView.delegate = self;
        
        BRScheduleViewLayout *breakLayout = [[BRScheduleViewLayout alloc] initWithScheduleView:self];
        breakLayout.keyPathForScheduleDurations = @"breakDurations";
        _breakCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:breakLayout];
        _breakCollectionView.backgroundColor = [UIColor clearColor];
        [_breakCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBreakCell];
        _breakCollectionView.dataSource = self;
        _breakCollectionView.delegate = self;
        
        _headerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_headerTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHeaderCell];
        _headerTableView.dataSource = self;
        _headerTableView.delegate = self;
        _headerTableView.allowsSelection = NO;
        
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        _backgroundView = [[BRScheduleBackgroundView alloc] initWithFrame:CGRectZero];
        _backgroundView.scheduleView = self;
        [_backgroundScrollView addSubview:_backgroundView];
        
        _touchForwardingView = [[BRTouchForwardingView alloc] initWithFrame:CGRectZero];
        _touchForwardingView.scheduleView = self;
        
        _captureScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_captureScrollView addSubview:_touchForwardingView];
        _captureScrollView.delegate = self;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView addSubview:_zoningCollectionView];
        [_contentView addSubview:_breakCollectionView];
        [_contentView addSubview:_headerTableView];
        
        [self addSubview:_backgroundScrollView];
        [self addSubview:_contentView];
        [self addSubview:_captureScrollView];
    }
    
    return self;
}

#pragma mark - Geometry

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    //CGPoint contentOffset = _captureScrollView.contentOffset;
    
    _captureScrollView.frame = bounds;
    
    //content view
        CGRect contentFrame = bounds;
        _contentView.frame = contentFrame;
    
    //collection views
    CGRect collectionFrame = bounds;
    collectionFrame = CGRectInsetFromLeft(collectionFrame, _headerWidth);
    collectionFrame = CGRectInsetFromTop(collectionFrame, _rulerHeight);
    _zoningCollectionView.frame = collectionFrame;
    _breakCollectionView.frame = collectionFrame;
    
    //background view
    CGRect backgroundScrollFrame = collectionFrame;
    _backgroundScrollView.frame = backgroundScrollFrame;
    
    //header table view frame
    CGRect headerFrame = bounds;
    headerFrame.size.width = _headerWidth;
    _headerTableView.frame = headerFrame;
    
    //backgroundview positioning
    CGRect backgroundFrame = CGRectZero;
    backgroundFrame.size = _scheduleContentSize;
    _backgroundView.frame = backgroundFrame;
    
    _touchForwardingView.frame = CGRectFromCGSize(_captureScrollView.contentSize);
    
    [self updateContentInsets];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    
    if (location.x <= _headerWidth) {
        self.firstResponder = _headerTableView;
    } else {
        UIView *breakHitTest = [_breakCollectionView hitTest:[self convertPoint:location toView:_breakCollectionView] withEvent:event];
        
        if (breakHitTest == _breakCollectionView) {
            self.firstResponder = _breakCollectionView;
        } else {
            self.firstResponder = _zoningCollectionView;
        }
    }
    
    [self.firstResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.firstResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.firstResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.firstResponder touchesCancelled:touches withEvent:event];
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
    _contentSize.width += _headerWidth;
    _contentSize.height += _rulerHeight;
    [self didChangeValueForKey:@"contentSize"];
    
    _captureScrollView.contentSize = _contentSize;
    _backgroundScrollView.contentSize = CGSizeMake(_contentSize.width, CGRectGetMaxY(self.bounds));
}

- (void)updateContentOffsets
{
    CGPoint contentOffset = _captureScrollView.contentOffset;
    _zoningCollectionView.contentOffset = contentOffset;
    _breakCollectionView.contentOffset = contentOffset;
    _backgroundScrollView.contentOffset = CGPointMake(contentOffset.x, 0);
    _headerTableView.contentOffset = CGPointMake(0, contentOffset.y - _rulerHeight);
}

- (void)updateContentInsets
{
    CGRect visibleRect = self.bounds;
    visibleRect.origin = _captureScrollView.contentOffset;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
	insets.top = _rulerHeight;
    _headerTableView.contentInset = insets;
    _headerTableView.scrollIndicatorInsets = insets;
    
    insets = UIEdgeInsetsZero;
	insets.left = visibleRect.origin.x >= -_headerWidth ? _headerWidth : -visibleRect.origin.x;
	insets.top = _rulerHeight;
	insets.right = MAX(CGRectGetMaxX(visibleRect) - _contentSize.width, 0);
	_captureScrollView.scrollIndicatorInsets = insets;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _captureScrollView) {
        [self updateContentOffsets];
        [self updateContentInsets];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == _zoningCollectionView) {
        return _zoningDurations.count;
    } else if (collectionView == _breakCollectionView) {
        return _breakDurations.count;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _zoningCollectionView) {
        NSArray *zonings = _zoningDurations[section];
        return zonings.count;
    } else if (collectionView == _breakCollectionView) {
        return [_breakDurations[section] count];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if (collectionView == _zoningCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZoningCell forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blueColor];
    } else if (collectionView == _breakCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBreakCell forIndexPath:indexPath];
        cell.backgroundColor = [UIColor orangeColor];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _zoningDurations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCell];
    cell.textLabel.text = @"Herp Derp";
    return cell;
}

#pragma mark - UITableViewDelegate

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
    [_zoningCollectionView.collectionViewLayout invalidateLayout];
    [_breakCollectionView.collectionViewLayout invalidateLayout];
    [self layoutIfNeeded];
}

@end
