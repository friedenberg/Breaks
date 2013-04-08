//
//  UIBarButtonItem+Additions.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/9/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "UIBarButtonItem+Additions.h"

@implementation UIBarButtonItem (Additions)

+ (UIBarButtonItem *)flexibleSpaceItem
{
	return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];
}

+ (UIBarButtonItem *)fixedSpaceItem
{
	return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
}

@end
