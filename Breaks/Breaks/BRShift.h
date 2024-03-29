//
//  BRStoreShift.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRDuration, BRBreak, BRZoning, BREmployee;

@interface BRShift : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *breaks;
@property (nonatomic, retain) BREmployee *employee;
@property (nonatomic, retain) NSOrderedSet *zonings;
@property (nonatomic, retain) BRDuration *duration;
@end

@interface BRShift (CoreDataGeneratedAccessors)

- (void)insertObject:(BRBreak *)value inBreaksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBreaksAtIndex:(NSUInteger)idx;
- (void)insertBreaks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBreaksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBreaksAtIndex:(NSUInteger)idx withObject:(BRBreak *)value;
- (void)replaceBreaksAtIndexes:(NSIndexSet *)indexes withBreaks:(NSArray *)values;
- (void)addBreaksObject:(BRBreak *)value;
- (void)removeBreaksObject:(BRBreak *)value;
- (void)addBreaks:(NSOrderedSet *)values;
- (void)removeBreaks:(NSOrderedSet *)values;
- (void)insertObject:(BRZoning *)value inZoningsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromZoningsAtIndex:(NSUInteger)idx;
- (void)insertZonings:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeZoningsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInZoningsAtIndex:(NSUInteger)idx withObject:(BRZoning *)value;
- (void)replaceZoningsAtIndexes:(NSIndexSet *)indexes withZonings:(NSArray *)values;
- (void)addZoningsObject:(BRZoning *)value;
- (void)removeZoningsObject:(BRZoning *)value;
- (void)addZonings:(NSOrderedSet *)values;
- (void)removeZonings:(NSOrderedSet *)values;
@end
