//
//  AACoreDataController.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/7/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AACoreDataController.h"

#import "BreaksAppDelegate.h"

//#import "AAOperationManager.h"
#import "AAObjectController.h"
#import "NSObject+Error.h"

#import "Employee.h"
#import "Break.h"
#import "Shift.h"
#import "Zoning.h"
#import "Zone.h"

#import "BreakProcessingOperation.h"


AAObjectController *ObjectController(void) { return [AppDelegate().coreDataController objectController]; };

NSManagedObjectContext *MainContext(void) { return [AppDelegate().coreDataController managedObjectContext]; };
NSPersistentStoreCoordinator *StoreCoordinator(void) { return [AppDelegate().coreDataController persistentStoreCoordinator]; };

NSString *DocumentsDirectory() { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; };

@implementation AACoreDataController

- (id)init
{
	if (self = [super init])
	{
		objectController = [[AAObjectController alloc] initWithManagedObjectContext:self.managedObjectContext];
		
		//[self deleteAllData];
		[self createSampleData];
	}
	
	return self;
}

@synthesize objectController;

- (void)applicationWillTerminate:(UIApplication *)application 
{
    [self saveContext];
}

- (void)saveContext 
{
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    

- (void)deleteAllData
{
	NSArray *stores = [self.persistentStoreCoordinator persistentStores];
	
	for(NSPersistentStore *store in stores) 
	{
		[persistentStoreCoordinator removePersistentStore:store error:nil];
		[[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
	}
	
	[persistentStoreCoordinator release], persistentStoreCoordinator = nil;
}

- (void)createSampleData
{	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *now = [NSDate date];
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:now];
	NSDate *today = [calendar dateFromComponents:dateComponents];
	
	NSMutableSet *shifts = [NSMutableSet new];
	
	Zone *evenZone = [NSEntityDescription insertNewObjectForEntityForName:@"Zone" inManagedObjectContext:managedObjectContext];
	Zone *oddZone = [NSEntityDescription insertNewObjectForEntityForName:@"Zone" inManagedObjectContext:managedObjectContext];
	
	evenZone.hexColor = @"c63e3e";
	oddZone.hexColor = @"4d9ee3";
	
	evenZone.name = @"Sales";
	oddZone.name = @"Setups";
	
	evenZone.section = @"Red Zone";
	oddZone.section = @"Family Room";
	
	for (int i = 0; i < 40; i++)
	{
		Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
		Shift *shift = [NSEntityDescription insertNewObjectForEntityForName:@"Shift" inManagedObjectContext:self.managedObjectContext];
		Zoning *zoningOne = [NSEntityDescription insertNewObjectForEntityForName:@"Zoning" inManagedObjectContext:self.managedObjectContext];
		Zoning *zoningTwo = [NSEntityDescription insertNewObjectForEntityForName:@"Zoning" inManagedObjectContext:self.managedObjectContext];
		
		zoningOne.shift = shift;
		zoningTwo.shift = shift;
		shift.employee = employee;
		employee.name = @"Fred Fergeson";
		
		NSTimeInterval shiftStart = (random() % 7) * 3600 + 25200;
		NSTimeInterval shiftEnd = shiftStart + 14400 + ((random() % 10) * 1800);
		
		shift.start = [today dateByAddingTimeInterval:shiftStart];
		shift.end = [today dateByAddingTimeInterval:shiftEnd];
		
		zoningOne.start = shift.start;
		zoningOne.end = [shift.start dateByAddingTimeInterval:(shift.duration) / 2];
		zoningTwo.start = zoningOne.end;
		zoningTwo.end = shift.end;
		
		zoningOne.shiftZone = i % 2 > 0 || i == 1 ? oddZone : evenZone;
		zoningTwo.shiftZone = i % 2 > 0 || i == 1 ? evenZone : oddZone;
		
		[shifts addObject:shift];
	}
	
	[self saveContext];
	[shifts makeObjectsPerformSelector:@selector(standardizeBreaks)];
	[self saveContext];
	[shifts release];
	
	NSOperationQueue *queue = [NSOperationQueue new];
	BreakProcessingOperation *operation = [BreakProcessingOperation new];
	operation.persistentStoreCoordinator = persistentStoreCoordinator;
	//[queue addOperation:operation];
	
	[queue release];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext 
{
    
    if (managedObjectContext) return managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	
    if (coordinator != nil) 
	{
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[managedObjectContext setMergePolicy:NSRollbackMergePolicy];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
		[managedObjectContext setRetainsRegisteredObjects:YES];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel 
{
    
    if (managedObjectModel) return managedObjectModel;
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Breaks" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
    
    if (persistentStoreCoordinator) return persistentStoreCoordinator;
    
    NSURL *storeURL = [[AppDelegate() applicationDocumentsDirectory] URLByAppendingPathComponent:@"Breaks.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
		
		persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
		{
			abort();
		}
		
    }    
    
    return persistentStoreCoordinator;
}

- (void)dealloc 
{
	[objectController release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];

    [super dealloc];
}


@end

