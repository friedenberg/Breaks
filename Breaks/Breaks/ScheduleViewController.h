//
//  ScheduleTableViewController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AAKit/AAKit.h>
#import "ScheduleViewDelegate.h"
#import "ScheduleViewDataSource.h"


@class Break, ScheduleView;

@interface ScheduleViewController : AAFetchedResultsViewController <UIPopoverControllerDelegate, UINavigationControllerDelegate, ScheduleViewDataSource, ScheduleViewDelegate>
{
    IBOutlet ScheduleView *scheduleView;
    UIPopoverController *popoverController;
	UIActionSheet *actionSheet;
	
	NSDateFormatter *breakDateFormatter;
	
	NSMutableSet *visibleZones;
}

@end
