//
//  BRShift.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/3/13.
//
//

#import "BRShift.h"
#import "BRBreak.h"
#import "BRDuration.h"
#import "BREmployee.h"
#import "BRZone.h"
#import "BRZoning.h"


@implementation BRShift

@dynamic breaks;
@dynamic duration;
@dynamic employee;
@dynamic zonings;
@dynamic zones;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    [self setPrimitiveValue:[NSEntityDescription insertNewObjectForEntityForName:@"BRDuration" inManagedObjectContext:self.managedObjectContext] forKey:@"duration"];
}

- (void)willSave
{
    [super willSave];
    
    NSSet *zones = [(NSOrderedSet *)[self.zonings valueForKey:@"sectionZone"] set];
    
    if (![self.zones isEqualToSet:zones]) {
        self.zones = zones;
    }
}

@end
