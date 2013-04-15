//
//  ZoneEditViewController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/3/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <AAKit/AAKit.h>


@class BRZone;

@interface ZoneEditViewController : AACoreDataViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *deleteButton;
	IBOutlet UITableViewCell *nameTableViewCell;
	IBOutlet UITextField *nameTextField;
}

+ (UIImage *)colorWellImageForColor:(UIColor *)color;

@property (nonatomic, strong) NSManagedObjectID *zoneObjectID;
@property (nonatomic, strong) BRZone *sectionZone;

- (IBAction)textFieldValueDidChange:(id)sender;

@end
