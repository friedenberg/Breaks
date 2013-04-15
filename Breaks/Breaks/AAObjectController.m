//
//  ModelRefreshController.m
//  Forecast
//
//  Created by Sasha Friedenberg on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AAObjectController.h"


NSString *const kDateChangeNotification = @"kDateChangeNotification";
NSString *const kMinuteChangeNotification = @"kMinuteChangeNotification";

@implementation AAObjectController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
	if ((self = [super init]))
	{
		assert(context);
		managedObjectContext = context;
		
		NSFetchRequest *request = [NSFetchRequest new];
		[request setEntity:[NSEntityDescription entityForName:@"BRShift" inManagedObjectContext:managedObjectContext]];
		[request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"duration.scheduledStartDate" ascending:YES]]];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
		fetchedResultsController.delegate = self;
		[request release];
		
		NSError *error = nil;
		[fetchedResultsController performFetch:&error];
		[error log];
		
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(didChangeSystemState:) name:NSSystemTimeZoneDidChangeNotification object:nil];
		[center addObserver:self selector:@selector(didChangeSystemState:) name:UIApplicationWillEnterForegroundNotification object:nil];
		
		calendar = [[NSCalendar autoupdatingCurrentCalendar] retain];
		
		NSDate *today = [NSDate date];
		
		NSDateComponents *components = [NSDateComponents new];
		components.minute = 1;
		
		NSDate *nextMinuteExact = [calendar dateByAddingComponents:components toDate:today options:0];
		
		[components release];
		
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
		components = [calendar components:unitFlags fromDate:nextMinuteExact];
		components.second = 0;
		
		NSDate *nextMinuteRounded = [calendar dateFromComponents:components];
		
		minuteTimer = [[NSTimer alloc] initWithFireDate:nextMinuteRounded interval:60 target:self selector:@selector(minuteTimer:) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:minuteTimer forMode:NSRunLoopCommonModes];
		[minuteTimer release];
	}
	
	return self;
}

- (void)didChangeSystemState:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kDateChangeNotification object:self];
}

- (void)minuteTimer:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kMinuteChangeNotification object:self];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	
}

- (void)dealloc
{
	[calendar release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[fetchedResultsController release];
	[super dealloc];
}

@end
