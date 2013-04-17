//
//  BRShiftBreak.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRBreak.h"
#import "BRDuration.h"
#import "BRShift.h"


@implementation BRBreak

@dynamic type;
@dynamic shift;
@dynamic duration;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    [self setPrimitiveValue:[NSEntityDescription insertNewObjectForEntityForName:@"BRDuration" inManagedObjectContext:self.managedObjectContext] forKey:@"duration"];
}

@end
