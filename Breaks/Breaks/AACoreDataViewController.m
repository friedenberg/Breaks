    //
//  AAGenericViewController.m
//  Chirp iPhone
//
//  Created by Sasha Friedenberg on 8/18/10.
//  Copyright 2010 Anodized Apps. All rights reserved.
//

#import "AACoreDataViewController.h"

#import "NSManagedObjectContextAdditions.h"


@interface AACoreDataViewController ()

- (void)didImportFromUbiquitiousContent:(id)sender;

@end

@implementation AACoreDataViewController

+ (NSManagedObjectContext *)mainContext
{
	return MainContext();
}

- (id)initWithDelegate:(id <AACoreDataViewControllerDelegate>)someObject managedObjectContext:(NSManagedObjectContext *)someContext
{
	abort();
}

- (id)initWithNibName:(NSString *)nibNameOrNil managedObjectContext:(NSManagedObjectContext *)aContext
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nil])
	{
		self.managedObjectContext = aContext;
	}
	
	return self;
}

@synthesize managedObjectContext, delegate;

static NSString *kContextChangeObservingContext = @"jerblaga";

- (void)setManagedObjectContext:(NSManagedObjectContext *)value
{
	NSManagedObjectContext *old = managedObjectContext;
	managedObjectContext = [value retain];
	
	[old removeObserver:self forKeyPath:@"hasChanges"];
	[managedObjectContext addObserver:self forKeyPath:@"hasChanges" options:NSKeyValueObservingOptionInitial context:kContextChangeObservingContext];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didImportFromUbiquitiousContent:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:nil];
	
	[old release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kContextChangeObservingContext)
	{
		[self managedObjectContextStateDidChange];
	}
	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)managedObjectContextStateDidChange
{
	
}

- (void)saveContext
{
	NSError *error = nil;
	[managedObjectContext save:&error];
	[self.delegate coreDataViewControllerDidSaveContext:self];
}

- (void)didImportFromUbiquitiousContent:(id)sender
{
	NSLog(@"%@", sender);
}

- (void)dealloc
{
	self.managedObjectContext = nil;
	[super dealloc];
}

@end
