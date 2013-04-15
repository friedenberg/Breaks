//
//  BRStoreSection.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRZone;

@interface BRSection : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *sectionZone;
@end

@interface BRSection (CoreDataGeneratedAccessors)

- (void)addSectionZoneObject:(BRZone *)value;
- (void)removeSectionZoneObject:(BRZone *)value;
- (void)addSectionZone:(NSSet *)values;
- (void)removeSectionZone:(NSSet *)values;

@end
