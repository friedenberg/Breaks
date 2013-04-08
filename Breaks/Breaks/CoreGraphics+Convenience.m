//
//  CoreGraphics+Convenience.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/21/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "CoreGraphics+Convenience.h"

CGRect CGRectInsetFromTop(CGRect rect, CGFloat inset)
{
	rect.origin.y += inset;
	rect.size.height -= inset;
	return rect;
}

CGRect CGRectInsetFromLeft(CGRect rect, CGFloat inset)
{
	rect.origin.x += inset;
	rect.size.width -= inset;
	return rect;
}

CGRect CGRectFromCGSize(CGSize size)
{
	CGRect rect = CGRectZero;
	rect.size = size;
	return rect;
}