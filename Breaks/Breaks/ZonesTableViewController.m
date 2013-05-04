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
{
    NSMutableSet *_selectedZones;
}

@end

@implementation ZonesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedZones = [NSMutableSet new];
    }
    
    return self;
}

#pragma mark - ZonesTableViewController

- (void)setSelectedZones:(NSSet *)value
{
    [_selectedZones setSet:value];
}

@dynamic delegate;

- (NSString *)sectionNameKeyPath
{
	return @"section.name";
}

- (void)modifyFetchRequest
{
	[self.fetchRequest setEntity:[NSEntityDescription entityForName:@"BRZone" inManagedObjectContext:self.managedObjectContext]];
	[self.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"section" ascending:YES],
     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	[super modifyFetchRequest];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Zones";
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
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.imageView.image = [ZoneEditViewController colorWellImageForColor:[UIColor colorWithHexString:zone.hexColor]];
	cell.textLabel.text = zone.name;
    
	BOOL isSelected = [_selectedZones containsObject:zone.objectID];
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
	
	BRZone *zone = [fetchedResultsController objectAtIndexPath:indexPath];
	
	if (self.editing)
	{
		NSManagedObjectContext *zoneEditContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[zoneEditContext setParentContext:self.managedObjectContext];
		
		ZoneEditViewController *controller = [[ZoneEditViewController alloc] initWithNibName:@"ZoneEditTableView" bundle:nil];
        controller.managedObjectContext = self.managedObjectContext;
        controller.zoneObjectID = zone.objectID;
		controller.delegate = self;
        
		[self.navigationController pushViewController:controller animated:YES];
	}
	else
	{
        NSManagedObjectID *zoneID = zone.objectID;
        BOOL isSelected = [_selectedZones containsObject:zoneID];
        
        if (isSelected) {
            [_selectedZones removeObject:zoneID];
            [self.delegate zonesTableViewController:self didDeselectZone:zoneID];
        } else {
            [_selectedZones addObject:zoneID];
            [self.delegate zonesTableViewController:self didSelectZone:zoneID];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];;
	}
}

- (void)coreDataViewControllerDidSaveContext:(AACoreDataViewController *)someController
{
	[self saveContext];
}


@end
