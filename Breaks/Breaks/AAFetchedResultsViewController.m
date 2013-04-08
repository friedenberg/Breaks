//
//  AAFetchedResultsViewController.m
//  
//
//  Created by Sasha Friedenberg on 27/07/11.
//  Copyright 2011 Anodized Apps. All rights reserved.
//

#import "AAFetchedResultsViewController.h"

#import "NSObject+Error.h"


@implementation AAFetchedResultsViewController

@synthesize fetchedResultsController, fetchRequest;

- (NSString *)cacheName
{
	return nil;
}

- (NSString *)sectionNameKeyPath
{
	return nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)modifyFetchRequest
{
	
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	assert(self.managedObjectContext);
	
	fetchRequest = [NSFetchRequest new];
	
	[self modifyFetchRequest];
	fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																   managedObjectContext:self.managedObjectContext 
																	 sectionNameKeyPath:self.sectionNameKeyPath 
																			  cacheName:self.cacheName];
	fetchedResultsController.delegate = self;
	
	[fetchRequest release];
	
	NSError *error = nil;
	[self fetchedResultsControllerWillFetch];
    [fetchedResultsController performFetch:&error];
	[error log];
	[self fetchedResultsControllerDidFetch];
	assert(!error);
}

- (void)performFetch
{
	[self modifyFetchRequest];
	
	NSError *error = nil;
	[self fetchedResultsControllerWillFetch];
    [fetchedResultsController performFetch:&error];
	[error log];
	[self fetchedResultsControllerDidFetch];
	assert(!error);
}

- (void)fetchedResultsControllerWillFetch
{
	
}

- (void)fetchedResultsControllerDidFetch
{

}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex 
	 forChangeType:(NSFetchedResultsChangeType)type
{
	
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	
}

- (void)viewDidUnload
{
	[fetchedResultsController release];
	fetchedResultsController = nil;
	[super viewDidUnload];
}

- (void)dealloc 
{
	[fetchedResultsController release];
    [super dealloc];
}

@end
