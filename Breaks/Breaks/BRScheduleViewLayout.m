//
//  BRScheduleViewLayout.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/15/13.
//
//

#import "BRScheduleViewLayout.h"

#import "BRScheduleView.h"
#import "BRScheduleView_PrivateLayoutAdditions.h"
#import "BRScheduleDuration.h"


@interface BRScheduleViewLayout ()
{
    CGSize _size;
    NSMutableArray *_layoutAttributes;
}

@end

@implementation BRScheduleViewLayout

- (instancetype)initWithScheduleView:(BRScheduleView *)someScheduleView
{
    if (self = [super init]) {
        _scheduleView = someScheduleView;
        _layoutAttributes = [NSMutableArray new];
    }
    
    return self;
}

- (CGSize)collectionViewContentSize
{
    return _size;
}

- (void)prepareLayout
{
    [_layoutAttributes removeAllObjects];
    
    CGFloat rowHeight = self.scheduleView.rowHeight;
    CGFloat hourWidth = self.scheduleView.hourWidth;
    NSRange hoursVisibleRange = self.scheduleView.hoursVisibleRange;
    
    NSDate *referenceDate = self.scheduleView.referenceDate;
    
    NSArray *shifts = [self.scheduleView valueForKeyPath:self.keyPathForScheduleDurations];
    
    _size.width = hoursVisibleRange.length * hourWidth;
    _size.height = shifts.count * rowHeight;
    
    NSUIntegerEnumerate(shifts.count, ^(NSUInteger shiftIndex) {
        
        NSArray *durations = shifts[shiftIndex];
        
        NSUIntegerEnumerate(durations.count, ^(NSUInteger durationIndex) {
            
            CGRect frame = CGRectZero;
            frame.origin.y = (rowHeight * shiftIndex);
            frame.size.height = rowHeight;
            
            BRScheduleDuration *duration = durations[durationIndex];
            
            NSTimeInterval locationInterval = [duration.startDate timeIntervalSinceDate:referenceDate];
            NSTimeInterval lengthInterval = [duration.endDate timeIntervalSinceDate:duration.startDate];
            
            frame.origin.x = ((CGFloat)locationInterval / 3600 - hoursVisibleRange.location) * hourWidth;
            frame.size.width = ((CGFloat)lengthInterval / 3600) * hourWidth;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:durationIndex inSection:shiftIndex];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = frame;
            
            [_layoutAttributes addObject:attributes];
            
        });
        
    });
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    //TODO: optimize based on rows visible
    [_layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [indexes addIndex:idx];
        }
        
    }];
    
    return [_layoutAttributes objectsAtIndexes:indexes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block UICollectionViewLayoutAttributes *found = nil;
    
    [_layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        
        if (attributes.indexPath.section == indexPath.section &&
            attributes.indexPath.item == indexPath.item) {
            found = attributes;
            *stop = YES;
        } else {
            return;
        }
        
    }];
    
    return found;
}

@end
