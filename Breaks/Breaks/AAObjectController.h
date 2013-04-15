//
//  ModelRefreshController.h
//  Forecast
//
//  Created by Sasha Friedenberg on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <AAKit/AAKit.h>


extern NSString *const kDateChangeNotification;
extern NSString *const kMinuteChangeNotification;

@interface AAObjectController : NSObject <NSFetchedResultsControllerDelegate>
{
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	
	NSCalendar *calendar;
	
	NSTimer *minuteTimer;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
