//
//  NSManagedObjectContextAdditions.m
//  Dispatch
//
//  Created by Sasha Friedenberg on 12/26/10.
//  Copyright 2010 Anodized Apps, LLC. All rights reserved.
//

#import "NSManagedObjectContextAdditions.h"


@implementation NSManagedObjectContext (NSManagedObjectContextAdditions)

static SEL saveSelector;
static NSString *notificationString;

+ (void)load
{
	saveSelector = @selector(mergeChangesFromContextDidSaveNotification:);
	notificationString = NSManagedObjectContextDidSaveNotification;
}

- (void)addObserverForSaveOperations:(id)observer
{
	if (![observer respondsToSelector:saveSelector]) return;
	NSString *notificationString = NSManagedObjectContextDidSaveNotification;
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:saveSelector name:notificationString object:self];
}

- (void)removeObserverForSaveOperations:(id)observer
{
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:notificationString object:self];
}

@end
