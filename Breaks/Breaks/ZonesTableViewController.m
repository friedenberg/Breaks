//
//  ZonesTableViewController.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/9/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ZonesTableViewController.h"

#import "UIColor-Expanded.h"
#import "ZoneEditViewController.h"

#import "BRModelObjects.h"


@interface ZonesTableViewController () <AACoreDataViewControllerDelegate>

@end

@implementation ZonesTableViewController

@dynamic delegate;

- (NSString *)sectionNameKeyPath
{
	return @"section";
}

- (void)modifyFetchRequest
{
	[self.fetchRequest setEntity:[NSEntityDescription entityForName:@"BRZone" inManagedObjectContext:self.managedObjectContext]];
	[self.fetchRequest setSortDescriptors:[NSArray arrayWithObjects:
										   [NSSortDescriptor sortDescriptorWithKey:@"section" ascending:YES],
										   [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil]];
	[super modifyFetchRequest];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Zones";
	
	[tableView layoutSubviews];
	self.contentSizeForViewInPopover = self.tableView.contentSize;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)someTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BRZone *zone = [self.fetchedResultsController objectAtIndexPath:indexPath];
	static NSString *identifier = @"Zone";
	UITableViewCell *cell = [someTableView dequeueReusableCellWithIdentifier:identifier];
	
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.imageView.image = [ZoneEditViewController colorWellImageForColor:[UIColor colorWithHexString:zone.hexColor]];
	cell.textLabel.text = zone.name;
	BOOL isSelected = [self.delegate.selectedZones containsObject:zone.objectID];
	cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)someTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[someTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UITableViewCell *cell = [someTableView cellForRowAtIndexPath:indexPath];
	BRZone *zone = [fetchedResultsController objectAtIndexPath:indexPath];
	
	if (self.editing)
	{
		NSManagedObjectContext *zoneEditContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[zoneEditContext setParentContext:self.managedObjectContext];
		
		ZoneEditViewController *controller = [[ZoneEditViewController alloc] initWithNibName:@"ZoneEditTableView" bundle:nil];
        controller.zoneObjectID = zone.objectID;
        controller.managedObjectContext = self.managedObjectContext;
		controller.delegate = self;
        
		[self.navigationController pushViewController:controller animated:YES];
	}
	else
	{
		if (cell.accessoryType == UITableViewCellAccessoryNone)
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			[self.delegate zonesTableViewController:self didSelectZone:zone.objectID];
		}
		else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
			[self.delegate zonesTableViewController:self didDeselectZone:zone.objectID];
		}
	}
}

- (void)coreDataViewControllerDidSaveContext:(AACoreDataViewController *)someController
{
	[self saveContext];
}


@end
