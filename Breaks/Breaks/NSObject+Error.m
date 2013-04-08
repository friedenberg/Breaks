//
//  NSObject+Error.m
//  Dispatch
//
//  Created by Sasha Friedenberg on 10/4/10.
//  Copyright 2010 Anodized Apps, LLC. All rights reserved.
//

#import "NSObject+Error.h"


@implementation NSObject (Additions)

- (BOOL)isError
{
	return [self isKindOfClass:[NSError class]];
}

@end

@implementation NSError (Logging)

- (void)log
{
	@try 
	{
		NSLog(@"%@\n%@", [self localizedDescription], [self userInfo]);
	}
	@catch (NSException * e) 
	{
		NSLog(@"%@", e);
		abort();
	}
}

@end