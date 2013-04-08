//
//  ZoneEditViewController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/3/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AACoreDataViewController.h"


@class Zone;

@interface ZoneEditViewController : AACoreDataViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *deleteButton;
	IBOutlet UITableViewCell *nameTableViewCell;
	IBOutlet UITextField *nameTextField;
	Zone *zone;
}

+ (UIImage *)colorWellImageForColor:(UIColor *)color;

- (id)initWithZoneObjectID:(NSManagedObjectID *)objectID managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (IBAction)textFieldValueDidChange:(id)sender;

@end
