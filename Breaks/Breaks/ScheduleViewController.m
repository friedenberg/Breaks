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
	
	NSMutableSet *visibleZones;
}

@property (nonatomic, strong) NSIndexPath *indexPathOfSelectedBreakObject;

- (void)zoneBarButtonItem:(id)sender;
- (void)breaksBarButtonItem:(id)sender;

- (BRZoning *)zoningObjectForIndexPath:(NSIndexPath *)indexPath;
- (BRBreak *)breakObjectForIndexPath:(NSIndexPath *)indexPath;

- (void)minuteDidChange:(id)sender;

@end

@implementation ScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil managedObjectContext:(NSManagedObjectContext *)aContext
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nil])
	{
        self.managedObjectContext = aContext;
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
	[request setEntity:[NSEntityDescription entityForName:@"BRShift" inManagedObjectContext:self.managedObjectContext]];
	[request setSortDescriptors:[NSArray arrayWithObjects:
								 [NSSortDescriptor sortDescriptorWithKey:@"duration.scheduledStartDate" ascending:YES],
								 [NSSortDescriptor sortDescriptorWithKey:@"duration.scheduledEndDate" ascending:YES],
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

#pragma mark - zones

- (void)zoneBarButtonItem:(id)sender
{
	if (popoverController.isPopoverVisible && [popoverController.contentViewController isKindOfClass:[ZonesTableViewController class]])
    {
        [popoverController dismissPopoverAnimated:YES];
    }
    else 
    {
        ZonesTableViewController *zonesController = [[ZonesTableViewController alloc] initWithNibName:@"ZonesTableView" bundle:nil];
        zonesController.delegate = self;
        zonesController.managedObjectContext = self.managedObjectContext;
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
    NSIndexPath *shiftIndexPath = [indexPath indexPathByRemovingLastIndex];
    BRShift *storeShift = [self.fetchedResultsController objectAtIndexPath:shiftIndexPath];
	return [storeShift.zonings objectAtIndex:[indexPath indexAtPosition:2]];
}

- (BRBreak *)breakObjectForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *shiftIndexPath = [indexPath indexPathByRemovingLastIndex];
    BRShift *storeShift = [self.fetchedResultsController objectAtIndexPath:shiftIndexPath];
	return [storeShift.breaks objectAtIndex:[indexPath indexAtPosition:2]];
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

- (NSString *)headerTitleAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	BREmployee *employee = [[self.fetchedResultsController objectAtIndexPath:indexPath] employee];
	return employee.name;
}

- (NSString *)hexColorForZoningAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
    BRZoning *zoning = [self zoningObjectForIndexPath:indexPath];
	BRZone *zone = zoning.sectionZone;
	return zone.hexColor;
}

- (UIImage *)imageForHeaderAccessoryAtIndex:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	BRShift *shift = [self.fetchedResultsController objectAtIndexPath:indexPath];
	return ([shift.duration containsDate:[NSDate date]]) ? [UIImage imageNamed:@"shiftIcon"] : nil;
}

- (UIImage *)imageForBreakAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView
{
	BRBreak *breakObject = [self breakObjectForIndexPath:indexPath];
	return breakObject.duration.scheduledDuration >= BRBreakTypeHalfLunch ? [UIImage imageNamed:@"lunchIcon"] : nil;
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
	BRBreak *breakObject = [self breakObjectForIndexPath:indexPath];
	
	NSString *buttonTitle = @"Mark as Ended";
	
	NSDate *timeTaken = breakObject.duration.actualStartDate;
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
