//
//  AACoreDataController.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/7/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BreaksAppDelegate, AAObjectController;

extern AAObjectController *ObjectController(void);
extern NSManagedObjectContext *MainContext(void);
extern NSPersistentStoreCoordinator *StoreCoordinator(void);

extern NSString *DocumentsDirectory();

extern NSString * const kPreferenceUsesFahrenheit;

@interface AACoreDataController : NSObject
{
	AAObjectController *objectController;
    
@private
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) AAObjectController *objectController;

- (void)saveContext;

- (void)deleteAllData;
- (void)createSampleData;

@end