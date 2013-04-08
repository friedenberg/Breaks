//
//  Shift.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/23/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduledObject.h"


typedef enum 
{
    ShiftTypeNoBreaks                   = 0,
    ShiftTypeOneBreak                   = 25,
    ShiftTypeTwoBreaks                  = 50,                
    ShiftTypeOneBreakAndOneHalfLunch    = 75,  
    ShiftTypeTwoBreaksAndOneFullLunch   = 150, 
    
} ShiftType;

@class Break, Employee, Zoning;

@interface Shift : ScheduledObject

@property (nonatomic, retain) NSOrderedSet *breaks;
@property (nonatomic, retain) Employee *employee;
@property (nonatomic, retain) NSOrderedSet *zonings;

@property (nonatomic, readonly) ShiftType type;

- (void)standardizeBreaks;

@end

@interface Shift (CoreDataGeneratedAccessors)

- (void)insertObject:(Break *)value inBreaksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBreaksAtIndex:(NSUInteger)idx;
- (void)insertBreaks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBreaksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBreaksAtIndex:(NSUInteger)idx withObject:(Break *)value;
- (void)replaceBreaksAtIndexes:(NSIndexSet *)indexes withBreaks:(NSArray *)values;
- (void)addBreaksObject:(Break *)value;
- (void)removeBreaksObject:(Break *)value;
- (void)addBreaks:(NSOrderedSet *)values;
- (void)removeBreaks:(NSOrderedSet *)values;
- (void)insertObject:(Zoning *)value inZoningsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromZoningsAtIndex:(NSUInteger)idx;
- (void)insertZonings:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeZoningsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInZoningsAtIndex:(NSUInteger)idx withObject:(Zoning *)value;
- (void)replaceZoningsAtIndexes:(NSIndexSet *)indexes withZonings:(NSArray *)values;
- (void)addZoningsObject:(Zoning *)value;
- (void)removeZoningsObject:(Zoning *)value;
- (void)addZonings:(NSOrderedSet *)values;
- (void)removeZonings:(NSOrderedSet *)values;
@end
