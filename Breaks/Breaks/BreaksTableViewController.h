//
//  BreaksTableViewController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <AAKit/AAKit.h>


@class BreaksTableViewController;

@protocol BreaksTableViewControllerDelegate <AACoreDataViewControllerDelegate>

- (void)breaksTableViewController:(BreaksTableViewController *)controller didSelectBreakWithManagedObjectID:(NSManagedObjectID *)objectID;

@end

@interface BreaksTableViewController : AAFetchedResultsTableViewController
{
	NSCalendar *calendar;
	IBOutlet UISegmentedControl *segmentedControl;
	IBOutlet UIBarButtonItem *segmentedControlBarButtonItem;
}

@property (nonatomic, weak) id <BreaksTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
