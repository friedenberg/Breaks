//
//  AAFetchedResultsTableViewController.m
//  Dispatch
//
//  Created by Sasha Friedenberg on 1/25/11.
//  Copyright 2011 Anodized Apps, LLC. All rights reserved.
//

#import "AAFetchedResultsTableViewController.h"


@implementation AAFetchedResultsTableViewController

@synthesize tableView;

- (void)viewWillAppear:(BOOL)animated 
{
	currentStyle = -1;
    [super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	UITableView *aTableView = self.tableView;
	
	[aTableView setEditing:editing animated:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSIndexPath *)fetchedResultsControllerIndexPathFromIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (NSIndexPath *)tableViewIndexPathFromIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	abort();
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
	assert(aTableView == self.tableView);
	isReordering = YES;
	[self.managedObjectContext processPendingChanges];
	isReordering = NO;
}

- (void)performBlock:(dispatch_block_t)block withTableViewRowAnimationStyle:(UITableViewRowAnimation)style
{
	currentStyle = style;
	block();
	currentStyle = -1;
}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	if (isReordering) return;
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex 
	 forChangeType:(NSFetchedResultsChangeType)type
{
	switch (type) 
	{
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	if (isReordering) return;
	
	UITableView *aTableView = self.tableView;
	NSIndexPath *newIP = [self tableViewIndexPathFromIndexPath:newIndexPath];
	NSIndexPath *oldIP = [self tableViewIndexPathFromIndexPath:indexPath];
	
	switch (type) 
	{	
		case NSFetchedResultsChangeInsert:
			[aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIP] withRowAnimation:currentStyle ?: UITableViewRowAnimationTop];
			break;
			
		case NSFetchedResultsChangeDelete:
			[aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:oldIP] withRowAnimation:currentStyle ?: UITableViewRowAnimationLeft];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[aTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:oldIP] withRowAnimation:currentStyle ?: UITableViewRowAnimationNone];
			break;
			
		case NSFetchedResultsChangeMove:
		{
			BOOL lowerPosition = oldIP.row < newIP.row;
			
			[aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:oldIP] 
							 withRowAnimation:currentStyle ?: (lowerPosition ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop)];
			
			[aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIP] 
							 withRowAnimation:currentStyle ?: (lowerPosition ? UITableViewRowAnimationTop : UITableViewRowAnimationBottom)];
		}
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	if (isReordering) return;
	[self.tableView endUpdates];
}

@end

