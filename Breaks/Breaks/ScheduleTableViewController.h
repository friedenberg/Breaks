//
//  ScheduleTableViewController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AAFetchedResultsTableViewController.h"
#import "AddEmployeeViewController.h"

@interface ScheduleTableViewController : AAFetchedResultsTableViewController <AddEmployeeViewControllerDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
}

@end
