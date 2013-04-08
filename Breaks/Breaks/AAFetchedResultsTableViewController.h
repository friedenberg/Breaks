//
//  AAFetchedResultsTableViewController.h
//  Dispatch
//
//  Created by Sasha Friedenberg on 1/25/11.
//  Copyright 2011 Anodized Apps, LLC. All rights reserved.
//

#import "AAFetchedResultsViewController.h"


@interface AAFetchedResultsTableViewController : AAFetchedResultsViewController <UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView *tableView;
	BOOL isReordering;
	
	UITableViewRowAnimation currentStyle;
}

@property (nonatomic, readonly) IBOutlet UITableView *tableView;

- (void)performBlock:(dispatch_block_t)block withTableViewRowAnimationStyle:(UITableViewRowAnimation)style;

- (NSIndexPath *)fetchedResultsControllerIndexPathFromIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableViewIndexPathFromIndexPath:(NSIndexPath *)indexPath;

@end