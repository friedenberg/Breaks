//
//  NSManagedObjectContextAdditions.h
//  Dispatch
//
//  Created by Sasha Friedenberg on 12/26/10.
//  Copyright 2010 Anodized Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (NSManagedObjectContextAdditions)

- (void)addObserverForSaveOperations:(id)aContext;
- (void)removeObserverForSaveOperations:(id)aContext;

@end
