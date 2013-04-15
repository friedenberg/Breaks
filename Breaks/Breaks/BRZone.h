//
//  BRSectionZone.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRRule, BRZoning, BRSection;

@interface BRZone : NSManagedObject

@property (nonatomic, strong) NSString * hexColor;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * section;
@property (nonatomic, strong) NSSet *zonings;
@property (nonatomic, strong) NSOrderedSet *sectionZoneRules;
@property (nonatomic, strong) BRSection *storeSection;
@end

@interface BRZone (CoreDataGeneratedAccessors)

- (void)addZoningsObject:(BRZoning *)value;
- (void)removeZoningsObject:(BRZoning *)value;
- (void)addZonings:(NSSet *)values;
- (void)removeZonings:(NSSet *)values;

- (void)insertObject:(BRRule *)value inSectionZoneRulesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSectionZoneRulesAtIndex:(NSUInteger)idx;
- (void)insertSectionZoneRules:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSectionZoneRulesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSectionZoneRulesAtIndex:(NSUInteger)idx withObject:(BRRule *)value;
- (void)replaceSectionZoneRulesAtIndexes:(NSIndexSet *)indexes withSectionZoneRules:(NSArray *)values;
- (void)addSectionZoneRulesObject:(BRRule *)value;
- (void)removeSectionZoneRulesObject:(BRRule *)value;
- (void)addSectionZoneRules:(NSOrderedSet *)values;
- (void)removeSectionZoneRules:(NSOrderedSet *)values;
@end
