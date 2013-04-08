//
//  ScheduleTableViewController.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleTableViewController.h"

#import "AddEmployeeViewController.h"

#import "Employee.h"
#import "Break.h"
#import "Shift.h"

#import "ScheduleTableViewCell.h"
#import "ScheduleView.h"

@interface ScheduleTableViewController ()

@end

@implementation ScheduleTableViewController

- (void)fetchRequestWillSet
{
	[self.fetchRequest setEntity:[NSEntityDescription entityForName:@"Shift" inManagedObjectContext:self.managedObjectContext]];
	//[self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"index.integerValue != -1"]];
	[self.fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//[(UIScrollView *)self.view setContentSize:contentSize];

    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEmployee:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem, addItem, nil];
    [addItem release];
}

- (void)addEmployee:(id)sender
{
    if (popoverController.isPopoverVisible)
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else 
    {
        NSManagedObjectContext *addContext = [NSManagedObjectContext new];
        [addContext setPersistentStoreCoordinator:StoreCoordinator()];
        [[NSNotificationCenter defaultCenter] addObserver:self.managedObjectContext selector:@selector(mergeChangesFromContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:addContext];
        
        AddEmployeeViewController *addController = [[AddEmployeeViewController alloc] initWithNibName:@"AddEmployeeView" managedObjectContext:addContext];
        addController.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
        
		if (!popoverController)
		{
			popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
			popoverController.delegate = self;
		}
		else popoverController.contentViewController = navigationController;
		
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)dismissAddEmployeeViewController
{
    [popoverController dismissPopoverAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ScheduleViewShiftBlock *cell = (ScheduleViewShiftBlock *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[[ScheduleViewShiftBlock alloc] initWithTable:(ScheduleView *)aTableView reuseIdentifier:CellIdentifier] autorelease];
    
    Shift *cellObject = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.employeeNameLabel.text = cellObject.employee.name;
    cell.shiftStart = cellObject.start;
    cell.shiftEnd = cellObject.end;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

@end
