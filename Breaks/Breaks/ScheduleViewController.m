//
//  ScheduleTableViewController.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"

#import "AAObjectController.h"

#import "ScheduleDetailViewController.h"
#import "ZonesTableViewController.h"
#import "BreaksTableViewController.h"

#import "ZoneDemandGraphViewController.h"

#import "BRModelObjects.h"
#import "BRShift+Additions.h"

#import "BRScheduleView.h"
#import "ScheduleViewZoningView.h"
#import "ScheduleViewHeaderView.h"

#import "UIViewController+Convenience.h"


@interface ScheduleViewController () <BreaksTableViewControllerDelegate, UIActionSheetDelegate, ZonesTableViewControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, BRScheduleViewDataSource, BRScheduleViewDelegate>
{
    IBOutlet BRScheduleView *scheduleView;
    UIPopoverController *popoverController;
	UIActionSheet *actionSheet;
	
	NSDateFormatter *breakDateFormatter;
	
	BOOL _shouldIgnoreFetchedResultsControllerContentUpdates;
}

@property (nonatomic, strong) ZonesTableViewController *zoneTableViewController;

@property (nonatomic, strong) NSIndexPath *indexPathOfSelectedBreakObject;

- (void)performBlockWhileIgnoringFetchedResultsControllerContentUpdates:(dispatch_block_t)block;

- (void)zoneBarButtonItem:(id)sender;
- (void)breaksBarButtonItem:(id)sender;

- (BRZoning *)zoningObjectForIndexPath:(NSIndexPath *)indexPath;
- (BRBreak *)breakObjectForIndexPath:(NSIndexPath *)indexPath;

- (void)minuteDidChange:(id)sender;

@end

@implementation ScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        breakDateFormatter = [NSDateFormatter new];
		[breakDateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[breakDateFormatter setDateStyle:NSDateFormatterNoStyle];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(minuteDidChange:)
													 name:kMinuteChangeNotification
												   object:nil];
        
        self.zoneTableViewController = [[ZonesTableViewController alloc] initWithNibName:@"ZonesTableView" bundle:nil];
        _zoneTableViewController.delegate = self;
    }
    
    return self;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)value
{
    [super setManagedObjectContext:value];
    _zoneTableViewController.managedObjectContext = value;
}

- (void)modifyFetchRequest
{
	NSFetchRequest *request = self.fetchRequest;
	[request setEntity:[NSEntityDescription entityForName:@"BRShift" inManagedObjectContext:self.managedObjectContext]];
	[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"duration.scheduledStartDate" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"duration.scheduledEndDate" ascending:YES]]];
	[request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"breaks", @"zonings.shiftZone", @"employee", nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSMutableArray *items = [NSMutableArray new];
	
	[items addObject:self.editButtonItem];
	
	[items addObject:[UIBarButtonItem flexibleSpaceItem]];
	
	UIBarButtonItem *breaksItem = [[UIBarButtonItem alloc] initWithTitle:@"Breaks" style:UIBarButtonItemStyleBordered target:self action:@selector(breaksBarButtonItem:)];
	[items addObject:breaksItem];
	
	UIBarButtonItem *zoneItem = [[UIBarButtonItem alloc] initWithTitle:@"Zones" style:UIBarButtonItemStyleBordered target:self action:@selector(zoneBarButtonItem:)];
	[items addObject:zoneItem];
	
    self.navigationItem.rightBarButtonItems = items;
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	//[scheduleView setEditing:editing animated:animated];
}

@synthesize indexPathOfSelectedBreakObject;

- (void)zoneBarButtonItem:(id)sender
{
	if (popoverController.isPopoverVisible && [popoverController.contentViewController isKindOfClass:[ZonesTableViewController class]])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_zoneTableViewController];
        
		if (!popoverController)
		{
			popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
			popoverController.delegate = self;
		}
		else popoverController.contentViewController = navigationController;
		
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - ZonesTableViewControllerDelegate

- (void)coreDataViewControllerDidSaveContext:(AACoreDataViewController *)someController
{
	//[scheduleView reloadSchedule];
}

- (void)zonesTableViewController:(ZonesTableViewController *)someController didSelectZone:(NSManagedObjectID *)objectID
{
    [self performBlockWhileIgnoringFetchedResultsControllerContentUpdates:^{
        
        [self performFetch];
        
    }];
}

- (void)zonesTableViewController:(ZonesTableViewController *)someController didDeselectZone:(NSManagedObjectID *)objectID
{

}

#pragma mark - breaks

- (void)breaksBarButtonItem:(id)sender
{
	if (popoverController.isPopoverVisible && [popoverController.contentViewController isKindOfClass:[BreaksTableViewController class]])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        BreaksTableViewController *controller = [[BreaksTableViewController alloc] initWithNibName:@"BreaksTableView" bundle:nil];
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
		controller.dateFormatter = breakDateFormatter;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        
		if (!popoverController)
		{
			popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
			popoverController.delegate = self;
		}
		else popoverController.contentViewController = navigationController;
		
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	
}

- (void)breaksTableViewController:(BreaksTableViewController *)breaksController didSelectBreakWithManagedObjectID:(NSManagedObjectID *)objectID
{
	NSError *error = nil;
	BRBreak *breakObject = (BRBreak *)[self.managedObjectContext existingObjectWithID:objectID error:&error];
	
	BRShift *shift = breakObject.shift;
	NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:shift];
	indexPath = [indexPath indexPathByAddingIndex:[shift.breaks indexOfObject:breakObject]];
	
	//[scheduleView scrollToBreakAtIndexPath:indexPath animated:YES];
	
	[popoverController dismissPopoverAnimated:YES];
	
	//[scheduleView scrollToBreakAtIndexPath:indexPath animated:YES];
}

#pragma mark - data convenience

- (BRZoning *)zoningObjectForIndexPath:(NSIndexPath *)indexPath
{
    BRShift *shift = self.fetchedResultsController.fetchedObjects[[indexPath indexAtPosition:0]];
	return [shift.zonings objectAtIndex:[indexPath indexAtPosition:1]];
}

- (BRBreak *)breakObjectForIndexPath:(NSIndexPath *)indexPath
{
    BRShift *shift = self.fetchedResultsController.fetchedObjects[[indexPath indexAtPosition:0]];
	return [shift.breaks objectAtIndex:[indexPath indexAtPosition:1]];
}

#pragma mark - popovers

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

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!_shouldIgnoreFetchedResultsControllerContentUpdates) {
        
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (!_shouldIgnoreFetchedResultsControllerContentUpdates) {
        
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!_shouldIgnoreFetchedResultsControllerContentUpdates) {
        
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (!_shouldIgnoreFetchedResultsControllerContentUpdates) {
        [scheduleView reloadSchedule];
    }
}

#pragma mark - BRScheduleViewDataSource

- (NSUInteger)numberOfShiftsInScheduleView:(BRScheduleView *)someScheduleView
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSUInteger)numberOfZoningsInShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView
{
    BRShift *shift = self.fetchedResultsController.fetchedObjects[shiftIndex];
	return shift.zonings.count;
}

- (NSUInteger)numberOfBreaksInShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView
{
    BRShift *shift = self.fetchedResultsController.fetchedObjects[shiftIndex];
	return shift.breaks.count;
}

- (BRScheduleDuration *)zoningDurationForZoning:(NSUInteger)zoningIndex forShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView
{
    BRShift *shift = self.fetchedResultsController.fetchedObjects[shiftIndex];
    BRZoning *zoning = shift.zonings[zoningIndex];
	return zoning.duration.portableDuration;
}

- (BRScheduleDuration *)breakDurationForBreak:(NSUInteger)breakIndex forShift:(NSUInteger)shiftIndex inScheduleView:(BRScheduleView *)someScheduleView
{
    BRShift *shift = self.fetchedResultsController.fetchedObjects[shiftIndex];
    BRBreak *shiftBreak = shift.breaks[breakIndex];
	return shiftBreak.duration.portableDuration;
}

#pragma mark - BRScheduleViewDelegate

static NSString *kHeaderTableViewCellIdentifier = @"kHeaderTableViewCellIdentifier";

- (UITableViewCell *)scheduleView:(BRScheduleView *)someScheduleView tableView:(UITableView *)someTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [someTableView dequeueReusableCellWithIdentifier:kHeaderTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kHeaderTableViewCellIdentifier];
    }
    
    BRShift *shift = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    cell.textLabel.text = shift.employee.name;
    cell.detailTextLabel.text = [shift titleForCurrentActivity];
    
    return cell;
}

- (void)scheduleView:(BRScheduleView *)someScheduleView didSelectBreakViewAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathOfSelectedBreakObject = indexPath;
	BRBreak *breakObject = [self breakObjectForIndexPath:indexPath];
	
	NSString *buttonTitle = @"Mark as Ended";
	
	NSDate *timeTaken = breakObject.duration.actualStartDate;
	NSString *title = nil;
	
    if (timeTaken) {
        title = [NSString stringWithFormat:@"Started at %@", [breakDateFormatter stringFromDate:timeTaken]];
    } else {
        buttonTitle = @"Mark as Started";
    }
	
	actionSheet = [[UIActionSheet alloc] initWithTitle:title
											  delegate:self
									 cancelButtonTitle:nil
								destructiveButtonTitle:nil
									 otherButtonTitles:buttonTitle, nil];
	
	CGRect rect = [someScheduleView rectForBreakAtIndexPath:indexPath];
	[actionSheet showFromRect:rect inView:someScheduleView animated:YES];
}

#pragma mark - ScheduleViewController

- (void)performBlockWhileIgnoringFetchedResultsControllerContentUpdates:(dispatch_block_t)block
{
    _shouldIgnoreFetchedResultsControllerContentUpdates = YES;
    block();
    _shouldIgnoreFetchedResultsControllerContentUpdates = NO;
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)someActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex < 0)
	{
		self.indexPathOfSelectedBreakObject = nil;
		return;
	}
	
	BRBreak *breakObject = [self breakObjectForIndexPath:self.indexPathOfSelectedBreakObject];
	
	NSString *buttonTitle = [someActionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:@"Mark as Started"])
	{
		breakObject.duration.actualStartDate = [NSDate date];
	}
	else
	{
		breakObject.duration.actualEndDate = [NSDate date];
	}
	
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	//[scheduleView reloadBreakAtIndexPath:self.indexPathOfSelectedBreakObject animated:YES];
	self.indexPathOfSelectedBreakObject = nil;
}

#pragma mark - notifications

- (void)minuteDidChange:(id)sender
{
	//scheduleView.timeheadDisplayDate = [NSDate date];
}


@end
