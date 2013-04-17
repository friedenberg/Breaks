//
//  BRShiftZoning.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRZoning.h"
#import "BRDuration.h"
#import "BRZone.h"
#import "BRShift.h"


@implementation BRZoning

@dynamic shift;
@dynamic sectionZone;
@dynamic duration;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    [self setPrimitiveValue:[NSEntityDescription insertNewObjectForEntityForName:@"BRDuration" inManagedObjectContext:self.managedObjectContext] forKey:@"duration"];
}


@end
