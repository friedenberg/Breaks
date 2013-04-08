//
//  BreakProcessingOperation.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/27/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "BreakProcessingOperation.h"

#import "Break.h"
#import "Zoning.h"
#import "Shift.h"
#import "Zone.h"


@interface BreakProcessingOperation ()

- (void)processBreaksForZone:(Zone *)zone;

@end

@implementation BreakProcessingOperation

- (void)process
{
	NSFetchRequest *request = [NSFetchRequest new];
	[request setEntity:[NSEntityDescription entityForName:@"Zone" inManagedObjectContext:managedObjectContext]];
	NSArray *zones = [managedObjectContext executeFetchRequest:request error:&incomingError];
	[self commitIncomingError];
	
	for (Zone *zone in zones)
		[self processBreaksForZone:zone];
}

- (void)processBreaksForZone:(Zone *)zone
{
//	NSSet *zonings = zone.zonings;
//	NSUInteger minimum = [[zonings valueForKeyPath:@"@min.start"] unsignedIntegerValue];
//	NSUInteger maximum = [[zonings valueForKeyPath:@"@max.end"] unsignedIntegerValue];
//	
//	NSRange zoneRange = NSMakeRange(minimum, maximum - minimum);
//	NSUInteger zoneGranularLength = zoneRange.length / 15;
//	
//	NSMutableArray *zoneOccupancies = [[NSMutableArray alloc] initWithCapacity:zoneGranularLength];
//	
//	for (int granularIndex = 0; granularIndex < zoneGranularLength; granularIndex++)
//	{
//		NSUInteger occupancy = 0;
//		NSUInteger timeIndex = (granularIndex * 25) + zoneRange.location;
//		
//		for (Zoning *zoning in zonings)
//			if (zoning.start <= timeIndex && zoning.end >= timeIndex + 25)
//				occupancy++;
//		
//		[zoneOccupancies addObject:[NSNumber numberWithUnsignedInteger:occupancy]];
//	}
//
//	//full lunches
//	
//	NSMutableArray *fullLunchPriorities = [[NSMutableArray alloc] initWithCapacity:zoneGranularLength];
//	
//	for (NSNumber *occupancy in zoneOccupancies)
//		[fullLunchPriorities addObject:[NSNumber numberWithFloat:[occupancy floatValue]]];
//	
//	[fullLunchPriorities sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]];
//	
//	
//	
//	[zoneOccupancies release];
}

@end
