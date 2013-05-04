//
//  BRZone.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/3/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRRule, BRSection, BRShift, BRZoning;

@interface BRZone : NSManagedObject

@property (nonatomic, retain) NSString * hexColor;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *rules;
@property (nonatomic, retain) BRSection *section;
@property (nonatomic, retain) NSSet *zonings;
@property (nonatomic, retain) NSSet *zones;
@end

@interface BRZone (CoreDataGeneratedAccessors)

- (void)insertObject:(BRRule *)value inRulesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRulesAtIndex:(NSUInteger)idx;
- (void)insertRules:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRulesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRulesAtIndex:(NSUInteger)idx withObject:(BRRule *)value;
- (void)replaceRulesAtIndexes:(NSIndexSet *)indexes withRules:(NSArray *)values;
- (void)addRulesObject:(BRRule *)value;
- (void)removeRulesObject:(BRRule *)value;
- (void)addRules:(NSOrderedSet *)values;
- (void)removeRules:(NSOrderedSet *)values;
- (void)addZoningsObject:(BRZoning *)value;
- (void)removeZoningsObject:(BRZoning *)value;
- (void)addZonings:(NSSet *)values;
- (void)removeZonings:(NSSet *)values;

- (void)addZonesObject:(BRShift *)value;
- (void)removeZonesObject:(BRShift *)value;
- (void)addZones:(NSSet *)values;
- (void)removeZones:(NSSet *)values;

@end
