//
//  ZonesTableViewController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/9/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <AAKit/AAKit.h>


@class ZonesTableViewController;

@protocol ZonesTableViewControllerDelegate <AACoreDataViewControllerDelegate>

@property (nonatomic, readonly) NSSet *selectedZones;

- (void)zonesTableViewController:(ZonesTableViewController *)someController didSelectZone:(NSManagedObjectID *)objectID;
- (void)zonesTableViewController:(ZonesTableViewController *)someController didDeselectZone:(NSManagedObjectID *)objectID;

@end

@interface ZonesTableViewController : AAFetchedResultsTableViewController
{
	
}

@property (nonatomic, weak) id <ZonesTableViewControllerDelegate> delegate;

@end
