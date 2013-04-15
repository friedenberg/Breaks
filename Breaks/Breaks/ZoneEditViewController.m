//
//  ZoneEditViewController.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/3/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ZoneEditViewController.h"

#import "UIColor-Expanded.h"

#import "BRModelObjects.h"


@interface ZoneEditViewController ()



@end

@implementation ZoneEditViewController

static NSArray *kColorHexKeys;
static NSArray *kColorNames;

+ (void)initialize
{
	if (self == [ZoneEditViewController class])
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"ZonesDefaultColors" ofType:@"plist"];
		NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
		kColorHexKeys = [[NSArray alloc] initWithArray:[plist valueForKey:@"hexKeys"]];
		kColorNames = [[NSArray alloc] initWithArray:[plist objectForKey:@"colorNames"]];
	}
}

+ (UIImage *)colorWellImageForColor:(UIColor *)color
{
	CGRect bounds = CGRectMake(0, 0, 15, 15);
	
	UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
	
	CGFloat hue, saturation, brightness, alpha;
	[color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	static CGFloat offset = 0.12;
	UIColor *strokeColor = [UIColor colorWithHue:hue saturation:saturation + offset brightness:brightness - offset alpha:1];
	
	[color set];
	[strokeColor setStroke];
	
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(bounds, 1, 1)];
	[roundedRect fill];
	[roundedRect stroke];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		self.editing = YES;
    }
	
    return self;
}

- (void)setZoneObjectID:(NSManagedObjectID *)value
{
    NSError *error = nil;
    BRZone *someZone = (id)[self.managedObjectContext existingObjectWithID:value error:&error];
    self.sectionZone = someZone;
}

- (NSManagedObjectID *)zoneObjectID
{
    return [self.sectionZone objectID];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = self.sectionZone.name;
	nameTextField.text = self.sectionZone.name;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueDidChange:) name:UITextFieldTextDidChangeNotification object:nameTextField];
	
	[tableView layoutSubviews];
	self.contentSizeForViewInPopover = tableView.contentSize;
}

- (void)managedObjectContextStateDidChange
{
	self.navigationItem.rightBarButtonItem.enabled = self.managedObjectContext.hasChanges;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	if (!editing)
	{
		[self saveContext];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
    if (section == 1) return kColorHexKeys.count;
	else return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) return @"Name";
	else if (section == 1) return @"Color";
	else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)someTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 0 && indexPath.row == 0) return nameTableViewCell;
	else if (indexPath.section == 2)
	{
		AADeleteButtonTableViewCell *cell = [[[AADeleteButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Delete"] autorelease];
		cell.textLabel.text = @"Delete Zone";
		return cell;
	}
	
	static NSString *identifier = @"Zone";
	UITableViewCell *cell = [someTableView dequeueReusableCellWithIdentifier:identifier];
	
	if (!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	}
	
	NSUInteger index = indexPath.row;
	
	NSString *colorName = [kColorNames objectAtIndex:index];
	NSString *hexColor = [kColorHexKeys objectAtIndex:index];
	
	cell.textLabel.text = colorName;
	cell.imageView.image = [[self class] colorWellImageForColor:[UIColor colorWithHexString:hexColor]];
	BOOL isSelected = [self.sectionZone.hexColor isEqualToString:hexColor];
	cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	return cell;
}

- (void)tableView:(UITableView *)someTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[someTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0) return;
	else if (indexPath.section == 2)
	{
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this Zone?"
																 delegate:self
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:@"Delete Zone" 
														otherButtonTitles:nil];
		[actionSheet showInView:self.view];
		[actionSheet release];
	}
	else
	{
		NSUInteger index = indexPath.row;
		
		UITableViewCell *cell = [someTableView cellForRowAtIndexPath:indexPath];
		NSString *hexColor = [kColorHexKeys objectAtIndex:index];
		
		NSUInteger indexOfOldSelection = [kColorHexKeys indexOfObject:self.sectionZone.hexColor];
		
		if (cell.accessoryType == UITableViewCellAccessoryNone)
		{
			UITableViewCell *oldCell = [someTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfOldSelection inSection:1]];
			oldCell.accessoryType = UITableViewCellAccessoryNone;
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			self.sectionZone.hexColor = hexColor;
		}
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	return YES;
}

- (IBAction)textFieldValueDidChange:(id)sender
{
	self.sectionZone.name = nameTextField.text;
	self.navigationItem.title = self.sectionZone.name;
}

- (void)dealloc
{
	[_sectionZone release];
	[super dealloc];
}

@end
