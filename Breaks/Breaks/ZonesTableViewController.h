//
//  ZonesTableViewController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/9/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AAFetchedResultsTableViewController.h"


@class ZonesTableViewController;

@protocol ZonesTableViewControllerDelegate <AACoreDataViewControllerDelegate>

@property (nonatomic, readonly) NSSet *selectedZones;

- (void)zonesTableViewController:(ZonesTableViewController *)someController didSelectZone:(NSManagedObjectID *)objectID;
- (void)zonesTableViewController:(ZonesTableViewController *)someController didDeselectZone:(NSManagedObjectID *)objectID;

@end

@interface ZonesTableViewController : AAFetchedResultsTableViewController
{
	
}

- (id)initWithDelegate:(id <ZonesTableViewControllerDelegate>)someObject managedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, assign) id <ZonesTableViewControllerDelegate> delegate;

@end
