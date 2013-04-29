//
//  AppDelegate.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BreaksAppDelegate.h"


#import "ScheduleViewController.h"
#import "ZoneDemandGraphViewController.h"

#import "BRModelObjects.h"
#import "BreakProcessingOperation.h"



BreaksAppDelegate *AppDelegate(void) { return (BreaksAppDelegate *)[[UIApplication sharedApplication] delegate]; };


@implementation BreaksAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _coreDataController = [[AACoreDataController alloc] initWithModelName:@"BRBreaks"];
	
    if (YES)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:now];
        NSDate *today = [calendar dateFromComponents:dateComponents];
        
        NSMutableSet *shifts = [NSMutableSet new];
        
        BRZone *evenZone = [NSEntityDescription insertNewObjectForEntityForName:@"BRZone" inManagedObjectContext:_coreDataController.managedObjectContext];
        BRZone *oddZone = [NSEntityDescription insertNewObjectForEntityForName:@"BRZone" inManagedObjectContext:_coreDataController.managedObjectContext];
        
        evenZone.hexColor = @"c63e3e";
        oddZone.hexColor = @"4d9ee3";
        
        evenZone.name = @"Sales";
        oddZone.name = @"Setups";
        
        evenZone.section = @"Red Zone";
        oddZone.section = @"Family Room";
        
        for (int i = 0; i < 40; i++)
        {
            BREmployee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"BREmployee" inManagedObjectContext:_coreDataController.managedObjectContext];
            BRShift *shift = [NSEntityDescription insertNewObjectForEntityForName:@"BRShift" inManagedObjectContext:_coreDataController.managedObjectContext];
            BRZoning *zoningOne = [NSEntityDescription insertNewObjectForEntityForName:@"BRZoning" inManagedObjectContext:_coreDataController.managedObjectContext];
            BRZoning *zoningTwo = [NSEntityDescription insertNewObjectForEntityForName:@"BRZoning" inManagedObjectContext:_coreDataController.managedObjectContext];
            
            zoningOne.shift = shift;
            zoningTwo.shift = shift;
            shift.employee = employee;
            employee.name = @"Fred Fergeson";
            
            NSTimeInterval shiftStart = (random() % 7) * 3600 + 25200;
            NSTimeInterval shiftEnd = shiftStart + 14400 + ((random() % 10) * 1800);
            
            shift.duration.scheduledStartDate = [today dateByAddingTimeInterval:shiftStart];
            shift.duration.scheduledEndDate = [today dateByAddingTimeInterval:shiftEnd];
            NSTimeInterval shiftDuration = shift.duration.scheduledDuration;
            
            zoningOne.duration.scheduledStartDate = shift.duration.scheduledStartDate;
            zoningOne.duration.scheduledEndDate = [shift.duration.scheduledStartDate dateByAddingTimeInterval:shiftDuration / 2];
            
            zoningTwo.duration.scheduledStartDate = zoningOne.duration.scheduledEndDate;
            zoningTwo.duration.scheduledEndDate = shift.duration.scheduledEndDate;
            
            zoningOne.sectionZone = i % 2 > 0 || i == 1 ? oddZone : evenZone;
            zoningTwo.sectionZone = i % 2 > 0 || i == 1 ? evenZone : oddZone;
            
            [shifts addObject:shift];
        }
        
        [_coreDataController save];
        [shifts makeObjectsPerformSelector:@selector(standardizeBreaks)];
        [_coreDataController save];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        BreakProcessingOperation *operation = [BreakProcessingOperation new];
        operation.persistentStoreCoordinator = _coreDataController.persistentStoreCoordinator;
        //[queue addOperation:operation];
        
    }
    
    ScheduleViewController *scheduleViewController = [[ScheduleViewController alloc] initWithNibName:nil bundle:nil];
    scheduleViewController.managedObjectContext = _coreDataController.managedObjectContext;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:scheduleViewController];
	navigationController.view.backgroundColor = [UIColor underPageBackgroundColor];
	
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [_coreDataController save];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
