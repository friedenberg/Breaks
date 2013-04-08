//
//  AAFetchedResultsViewController.h
//  
//
//  Created by Sasha Friedenberg on 27/07/11.
//  Copyright 2011 Anodized Apps. All rights reserved.
//

#import "AACoreDataViewController.h"
//#import "UIViewControllerAdditions.h"

@interface AAFetchedResultsViewController : AACoreDataViewController <NSFetchedResultsControllerDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
	NSFetchRequest *fetchRequest;
}

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, readonly) NSFetchRequest *fetchRequest;
@property (nonatomic, readonly) NSString *cacheName;
@property (nonatomic, readonly) NSString *sectionNameKeyPath;

- (void)performFetch;

- (void)modifyFetchRequest;

- (void)fetchedResultsControllerWillFetch;
- (void)fetchedResultsControllerDidFetch;

@end
