//
//  BRStoreEmployee.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRShift;

@interface BREmployee : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *shifts;
@end

@interface BREmployee (CoreDataGeneratedAccessors)

- (void)addShiftsObject:(BRShift *)value;
- (void)removeShiftsObject:(BRShift *)value;
- (void)addShifts:(NSSet *)values;
- (void)removeShifts:(NSSet *)values;

@end
