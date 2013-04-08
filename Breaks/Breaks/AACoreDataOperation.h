//
//  AACoreDataOperation.h
//  Dispatch
//
//  Created by Sasha Friedenberg on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AAOperation.h"


@interface AACoreDataOperation : AAOperation 
{
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectContext *managedObjectContext;
	NSMutableSet *observingContexts;
}

@property (nonatomic, readonly) BOOL needsManagedObjectContext;
@property (nonatomic, readonly) BOOL shouldSaveManagedObjectContext;
@property (nonatomic, readonly) BOOL shouldSaveMainManagedObjectContext;

@property (nonatomic, assign) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (void)addObservingContext:(NSManagedObjectContext *)context;
- (void)removeObservingContext:(NSManagedObjectContext *)context;

- (void)createContext;

- (void)process;

- (void)contextWillSave;
- (void)saveContext;
- (void)contextDidSave;

- (void)mergeChangesFromContextDidSaveNotification:(NSNotification *)aNotification;

@end
