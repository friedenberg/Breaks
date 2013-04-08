//
//  AAOperation.m
//  Dispatch
//
//  Created by Sasha Friedenberg on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AAOperation.h"

#import "NSObject+Error.h"


@implementation AAOperation

@synthesize error, callingThread;

- (id)init
{
	if ((self = [super init]))
	{
		callingThread = [[NSThread currentThread] retain];
	}
	
	return self;
}

- (void)addDependencies:(NSSet *)dependencies
{
	for (NSOperation *operation in dependencies) [self addDependency:operation];
}

- (void)cancel
{
	[self commitError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
	[super cancel];
}

#pragma mark -
#pragma mark Error Management

- (void)commitError:(NSError *)anError
{
	if (!anError) return;
	
	[anError log];
	
	if (self.error)
	{
		NSArray *detailedErrors = [[self.error userInfo] objectForKey:NSDetailedErrorsKey];
		if (!detailedErrors) detailedErrors = [NSArray arrayWithObject:anError];
		
		NSDictionary *info = [NSDictionary dictionaryWithObject:detailedErrors forKey:NSDetailedErrorsKey];
		
		self.error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:info];
	}
	else self.error = anError;
}

- (void)commitIncomingError
{
	[self commitError:incomingError];
	incomingError = nil;
}

- (void)dealloc
{
	[callingThread release];
    self.error = nil;
	[super dealloc];
}

@end
