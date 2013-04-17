//
//  BRStoreShift.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import "BRShift.h"
#import "BRDuration.h"
#import "BRBreak.h"
#import "BRZoning.h"
#import "BREmployee.h"


@implementation BRShift

@dynamic breaks;
@dynamic employee;
@dynamic zonings;
@dynamic duration;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    [self setPrimitiveValue:[NSEntityDescription insertNewObjectForEntityForName:@"BRDuration" inManagedObjectContext:self.managedObjectContext] forKey:@"duration"];
}

@end
