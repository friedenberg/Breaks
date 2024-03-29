//
//  BreaksTableViewController.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "BreaksTableViewController.h"

#import "AAObjectController.h"

#import "BRModelObjects.h"


@interface BreaksTableViewController ()

- (void)minuteDidChange:(NSNotification *)notification;

@end

@implementation BreaksTableViewController

static UIColor *defaultDetailTextLabelTextColor;
static UIColor *invalidDetailTextLabelColor;

+ (void)initialize
{
	if (self == [BreaksTableViewController class])
	{
		defaultDetailTextLabelTextColor = [[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1] retain];
		invalidDetailTextLabelColor = [[UIColor colorWithRed:0.507 green:0.227 blue:0.234 alpha:1.000] retain];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        calendar = [[NSCalendar currentCalendar] retain];
    }
    
    return self;
}

@dynamic delegate;
@synthesize dateFormatter;

- (NSString *)sectionNameKeyPath
{
	return @"sectionTitle";
}

- (void)modifyFetchRequest
{
	[self.fetchRequest setEntity:[NSEntityDescription entityForName:@"Break" inManagedObjectContext:self.managedObjectContext]];
	[self.fetchRequest setSortDescriptors:[NSArray arrayWithObjects:
										   [NSSortDescriptor sortDescriptorWithKey:@"timeTaken" ascending:YES],
										   [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES], nil]];
	[self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timeTaken != nil"]];
	//[self.fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"shift.employee.name"]];
	
	[super modifyFetchRequest];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Breaks";
	
	self.toolbarItems = [NSArray arrayWithObjects:[UIBarButtonItem flexibleSpaceItem], segmentedControlBarButtonItem, [UIBarButtonItem flexibleSpaceItem], nil];
	self.navigationController.toolbarHidden = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minuteDidChange:) name:kMinuteChangeNotification object:nil];
	[self minuteDidChange:nil];
	
	[tableView layoutSubviews];
	self.contentSizeForViewInPopover = tableView.contentSize;
}

- (void)minuteDidChange:(NSNotification *)notification
{
	[tableView beginUpdates];
	
	[tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
	
	[tableView endUpdates];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)someTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BRBreak *breakObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	static NSString *identifier = @"Break";
	UITableViewCell *cell = [someTableView dequeueReusableCellWithIdentifier:identifier];
	
	if (!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = breakObject.shift.employee.name;
	NSString *detailText = nil;
	UIColor *detailColor = nil;
	
	if ([breakObject.duration.actualStartDate isEqualToDate:[NSDate distantFuture]])
	{
		detailText = [NSString stringWithFormat:@"Starts at %@", [dateFormatter stringFromDate:breakObject.duration.scheduledStartDate]];
		detailColor = [[NSDate date] isEarlierThanDate:breakObject.duration.scheduledStartDate] ? defaultDetailTextLabelTextColor : invalidDetailTextLabelColor;
	}
	else 
	{
		BRTimeInterval duration = breakObject.duration.scheduledStartDate;
		NSDate *endDate = [breakObject.duration.actualStartDate dateByAddingTimeInterval:duration];
		BRTimeInterval remainingInterval = [endDate timeIntervalSinceDate:[NSDate date]];
		
		NSInteger remainingSeconds = fmod(remainingInterval, 60);
		NSInteger remainingMinutes = (remainingInterval - remainingSeconds) / 60;
		
		detailText = [NSString stringWithFormat:remainingMinutes >= 0 ? @"Ends in %im" : @"Over by %im", (abs(remainingMinutes))];
		detailColor = remainingMinutes >= 0 ? defaultDetailTextLabelTextColor : invalidDetailTextLabelColor;
	}
	
	cell.detailTextLabel.text = detailText;
	cell.detailTextLabel.textColor = detailColor;
	
	cell.imageView.image = breakObject.duration.scheduledDuration == BRBreakTypeFifteen ? [UIImage imageNamed:@"fifteenIcon"] : [UIImage imageNamed:@"lunchIcon"];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BRBreak *breakObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[self.delegate breaksTableViewController:self didSelectBreakWithManagedObjectID:[breakObject objectID]];
}

- (void)dealloc
{
	[calendar release];
	[dateFormatter release];
	[super dealloc];
}

@end
