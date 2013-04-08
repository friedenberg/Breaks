//
//  AAGenericViewController.h
//  Chirp iPhone
//
//  Created by Sasha Friedenberg on 8/18/10.
//  Copyright 2010 Anodized Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class AACoreDataViewController;

@protocol AACoreDataViewControllerDelegate <NSObject>

- (void)coreDataViewControllerDidSaveContext:(AACoreDataViewController *)someController;

@end

@interface AACoreDataViewController : UIViewController 
{
	NSManagedObjectContext *managedObjectContext;
	id <AACoreDataViewControllerDelegate> delegate;
}

+ (NSManagedObjectContext *)mainContext;

- (id)initWithDelegate:(id <AACoreDataViewControllerDelegate>)someObject managedObjectContext:(NSManagedObjectContext *)someContext;
- (id)initWithNibName:(NSString *)nibNameOrNil managedObjectContext:(NSManagedObjectContext *)aContext;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) id <AACoreDataViewControllerDelegate> delegate;

- (void)managedObjectContextStateDidChange;
- (void)saveContext;

@end
