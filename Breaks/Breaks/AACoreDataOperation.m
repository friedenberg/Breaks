//
//  AACoreDataOperation.m
//  Dispatch
//
//  Created by Sasha Friedenberg on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AACoreDataOperation.h"
#import "NSManagedObjectContextAdditions.h"
#import "GrandCentralDispatchAdditions.h"


@implementation AACoreDataOperation

- (id)init
{
	if ((self = [super init]))
	{
		if (self.needsManagedObjectContext)
		{
			self.persistentStoreCoordinator = StoreCoordinator();
			observingContexts = [[NSMutableSet alloc] initWithObjects:MainContext(), nil];
		}
	}
	
	return self;
}

- (BOOL)needsManagedObjectContext
{
	return YES;
}

- (BOOL)shouldSaveManagedObjectContext
{
	return !error && self.needsManagedObjectContext && managedObjectContext;
}

@synthesize managedObjectContext, persistentStoreCoordinator;

- (void)main
{
	NSAutoreleasePool *pool = nil;
	
	@try 
	{
		pool = [[NSAutoreleasePool alloc] init];
		if (self.needsManagedObjectContext) [self createContext];
		[self process];
		if (self.needsManagedObjectContext && self.shouldSaveManagedObjectContext) [self saveContext];
	}
	@catch (NSException * e) 
	{
		NSLog(@"%@", e);
	}
	@finally 
	{
		[pool drain];
	}
}

- (BOOL)shouldSaveMainManagedObjectContext
{
	return YES;
}

- (void)createContext
{
	if (self.shouldSaveMainManagedObjectContext) dispatch_main_sync(^{ [MainContext() save:&self->incomingError]; [self commitIncomingError]; });
	
    managedObjectContext = [[NSManagedObjectContext alloc] init];
	[managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
	managedObjectContext.undoManager = nil;
	managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChangesFromContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
}

- (void)process
{
	
}

- (void)contextWillSave
{
	
}

- (void)saveContext
{
	@try 
	{
		[self contextWillSave];
		[persistentStoreCoordinator lock];
		[self.managedObjectContext save:&self->incomingError];
		[persistentStoreCoordinator unlock];
		[self commitIncomingError];
		if (self.error) NSLog(@"post-save-error for operation %@: %@", self, self.error);
		[self contextDidSave];
	}
	@catch (NSException * e) 
	{
		NSLog(@"%@", e);
	}
}

- (void)contextDidSave
{
	
}

- (void)addObservingContext:(NSManagedObjectContext *)context
{
	assert([NSThread isMainThread]);
	if (![observingContexts containsObject:context]) [observingContexts addObject:context];
}

- (void)removeObservingContext:(NSManagedObjectContext *)context
{
	assert([NSThread isMainThread]);
	if ([observingContexts containsObject:context]) [observingContexts removeObject:context];
}

- (void)mergeChangesFromContextDidSaveNotification:(NSNotification *)aNotification
{
	for (id c in observingContexts) [c performSelectorOnMainThread:_cmd withObject:aNotification waitUntilDone:NO];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[observingContexts release];
	[managedObjectContext removeObserverForSaveOperations:self];
	[managedObjectContext release];
	[super dealloc];
}

@end
