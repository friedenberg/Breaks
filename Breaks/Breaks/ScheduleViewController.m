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

#import "Employee.h"
#import "Break.h"
#import "Shift.h"
#import "Zoning.h"
#import "Zone.h"

#import "ScheduleView.h"
#import "ScheduleViewZoningView.h"
#import "ScheduleViewHeaderView.h"

#import "UIBarButtonItem+Additions.h"
#import "UIViewController+Convenience.h"


@interface ScheduleViewController () <BreaksTableViewControllerDelegate, UIActionSheetDelegate, ZonesTableViewControllerDelegate>

@property (nonatomic, retain) NSIndexPath *indexPathOfSelectedBreakObject;

- (void)zoneBarButtonItem:(id)sender;
- (void)breaksBarButtonItem:(id)sender;

- (Zoning *)zoningObjectForIndexPath:(NSIndexPath *)indexPath;
- (Break *)breakObjectForIndexPath:(NSIndexPath *)indexPath;

- (void)minuteDidChange:(id)sender;

@end

@implementation ScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil managedObjectContext:(NSManagedObjectContext *)aContext
{
	if (self = [super initWithNibName:nibNameOrNil managedObjectContext:aContext])
	{
		visibleZones = [NSMutableSet new];
		breakDateFormatter = [NSDateFormatter new];
		[breakDateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[breakDateFormatter setDateStyle:NSDateFormatterNoStyle];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(minuteDidChange:) 
													 name:kMinuteChangeNotification 
												   object:nil];
	}
	
	return self;
}

- (void)modifyFetchRequest
{
	NSFetchRequest *request = self.fetchRequest;
	[request setEntity:[NSEntityDescription entityForName:@"Shift" inManagedObjectContext:self.managedObjectContext]];
	[request setSortDescriptors:[NSArray arrayWithObjects:
								 [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES],
								 [NSSortDescriptor sortDescriptorWithKey:@"end" ascending:YES],
								 nil]];
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
	[breaksItem release];
	
	UIBarButtonItem *zoneItem = [[UIBarButtonItem alloc] initWithTitle:@"Zones" style:UIBarButtonItemStyleBordered target:self action:@selector(zoneBarButtonItem:)];
	[items addObject:zoneItem];
	[zoneItem release];
	
    self.navigationItem.rightBarButtonItems = items;
	
	[items release];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	ZoneDemandGraphViewController *demandController = [[ZoneDemandGraphViewController alloc] initWithNibName:@"ZoneDemandGraphView" bundle:nil];
	[self.navigationController presentModalViewController:demandController animated:animated wrapInNavigationController:YES];
	[demandController release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	[scheduleView  setEditing:editing animated:animated];
}

@synthesize indexPathOfSelectedBreakObject;

#pragma mark - zones

- (void)zoneBarButtonItem:(id)sender
{
	if (popoverController.isPopoverVisible && [popoverController.contentViewController isKindOfClass:[ZonesTableViewController class]])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else 
    {
        ZonesTableViewController *zonesController = [[ZonesTableViewController alloc] initWithDelegate:self managedObjectContext:managedObjectContext];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:zonesController];
        
		if (!popoverController)
		{
			popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
			popoverController.delegate = self;
		}
		else popoverController.contentViewController = navigationController;
		
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)coreDataViewControllerDidSaveContext:(AACoreDataViewController *)someController
{
	[scheduleView reloadSchedule];
}

- (NSSet *)selectedZones
{
	return visibleZones;
}

- (void)zonesTableViewController:(ZonesTableViewController *)someController didSelectZone:(NSManagedObjectID *)objectID
{
	[visibleZones addObject:objectID];
	[self performFetch];
}

- (void)zonesTableViewController:(ZonesTableViewController *)someController didDeselectZone:(NSManagedObjectID *)objectID
{
	[visibleZones removeObject:objectID];
	[self performFetch];
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
        BreaksTableViewController *controller = [[BreaksTableViewController alloc] initWithDelegate:self managedObjectContext:managedObjectContext];
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
	Break *breakObject = (Break *)[self.managedObjectContext existingObjectWithID:objectID error:&error];
	
	Shift *shift = breakObject.shift;
	NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:shift];
	indexPath = [indexPath indexPathByAddingIndex:[shift.breaks indexOfObject:breakObject]];
	
	[scheduleView scrollToBreakAtIndexPath:indexPath animated:YES];
	
	[popoverController dismissPopoverAnimated:YES];
	
	[scheduleView scrollToBreakAtIndexPath:indexPath animated:YES];
}

#pragma mark - data convenience

- (Zoning *)zoningObjectForIndexPath:(NSIndexPath *)indexPath
{
	return [[[self.fetchedResultsController objectAtIndexPath:[indexPath indexPathByRemovingLastIndex]] zonings] objectAtIndex:[indexPath indexAtPosition:2]];
}

- (Break *)breakObjectForIndexPath:(NSIndexPath *)indexPath
{
	return [[[self.fetchedResultsController objectAtIndexPath:[indexPath indexPathByRemovingLastIndex]] breaks] objectAtIndex:[indexPath indexAtPosition:2]];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [scheduleView reloadSchedule];
}

#pragma mark - schedule view data source

- (NSUInteger)numberOfSectionsInScheduleView:(ScheduleView *)someScheduleView
{
	return 1;
}

- (NSUInteger)numberOfShiftsInSection:(NSUInteger)section inScheduleView:(ScheduleView *)someScheduleView
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSUInteger)numberOfZoningsAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	return [[self.fetchedResultsController objectAtIndexPath:indexPath] zonings].count;
}

- (NSUInteger)numberOfBreaksAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	return [[self.fetchedResultsController objectAtIndexPath:indexPath] breaks].count;
}

- (id <ScheduleViewObject>)shiftObjectForIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (id <ScheduleViewObject>)zoningObjectForIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	return [[[self.fetchedResultsController objectAtIndexPath:[indexPath indexPathByRemovingLastIndex]] zonings] objectAtIndex:[indexPath indexAtPosition:2]];
}

- (id <ScheduleViewObject>)breakObjectForIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	return [[[self.fetchedResultsController objectAtIndexPath:[indexPath indexPathByRemovingLastIndex]] breaks] objectAtIndex:[indexPath indexAtPosition:2]];
}

#pragma mark - schedule view delegate

- (NSString *)headerTitleAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	Employee *employee = [[self.fetchedResultsController objectAtIndexPath:indexPath] employee];
	return employee.name;
}

- (NSString *)hexColorForZoningAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	Zone *zone = [[self zoningObjectForIndexPath:indexPath] shiftZone];
	return zone.hexColor;
}

- (UIImage *)imageForHeaderAccessoryAtIndex:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	Shift *shift = [self.fetchedResultsController objectAtIndexPath:indexPath];
	return ([shift containsDate:[NSDate date]]) ? [UIImage imageNamed:@"shiftIcon"] : nil;
}

- (UIImage *)imageForBreakAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	Break *breakObject = [self breakObjectForIndexPath:indexPath];
	return breakObject.duration >= BreakTypeHalfLunch ? [UIImage imageNamed:@"lunchIcon"] : nil;
}

- (void)scheduleView:(ScheduleView *)someScheduleView didSelectZoningViewAtIndexPath:(NSIndexPath *)indexPath
{
	/*ScheduleDetailViewController *controller = [[ScheduleDetailViewController alloc] initWithNibName:@"ScheduleDetailView" bundle:nil];
	 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	 
	 if (!popoverController)
	 {
	 popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
	 popoverController.delegate = self;
	 }
	 else popoverController.contentViewController = navigationController;
	 
	 [popoverController presentPopoverFromRect:frame inView:scheduleView permittedArrowDirections:UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight animated:YES];*/
}

- (void)scheduleView:(ScheduleView *)someScheduleView didSelectBreakViewAtIndexPath:(NSIndexPath *)indexPath
{
	self.indexPathOfSelectedBreakObject = indexPath;
	Break *breakObject = [self breakObjectForIndexPath:indexPath];
	
	NSString *buttonTitle = @"Mark as Ended";
	
	NSDate *timeTaken = breakObject.timeTaken;
	NSString *title = nil;
	
	if (!timeTaken) 
		return;
	else if ([timeTaken isEqualToDate:[NSDate distantFuture]])
		buttonTitle = @"Mark as Started";
	else
		title = [NSString stringWithFormat:@"Started at %@", [breakDateFormatter stringFromDate:timeTaken]];
	
	actionSheet = [[UIActionSheet alloc] initWithTitle:title
											  delegate:self 
									 cancelButtonTitle:nil 
								destructiveButtonTitle:nil 
									 otherButtonTitles:buttonTitle, nil];
	
	CGRect rect = [someScheduleView rectForBreakAtIndexPath:indexPath];
	[actionSheet showFromRect:rect inView:someScheduleView animated:YES];
	[actionSheet release];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)someActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex < 0)
	{
		self.indexPathOfSelectedBreakObject = nil;
		return;
	}
	
	Break *breakObject = [self breakObjectForIndexPath:self.indexPathOfSelectedBreakObject];
	
	NSString *buttonTitle = [someActionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:@"Mark as Started"])
	{
		[breakObject startBreak];
	}
	else
	{
		[breakObject endBreak];
	}
	
	NSError *error = nil;
	[managedObjectContext save:&error];
	[scheduleView reloadBreakAtIndexPath:self.indexPathOfSelectedBreakObject animated:YES];
	self.indexPathOfSelectedBreakObject = nil;
}

#pragma mark - notifications

- (void)minuteDidChange:(id)sender
{
	scheduleView.timeheadDisplayDate = [NSDate date];
}

- (void)dealloc
{
	[breakDateFormatter release];
	[visibleZones release];
	[super dealloc];
}

@end
