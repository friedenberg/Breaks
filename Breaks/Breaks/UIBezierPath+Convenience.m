//
//  UIBezierPath+Convenience.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/17/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "UIBezierPath+Convenience.h"

@implementation UIBezierPath (Convenience)

- (void)addCurveToPoint:(CGPoint)endPoint controlPointOffset:(CGFloat)offset
{
	CGPoint startPoint = self.currentPoint;
	
	CGPoint controlPoint1 = CGPointMake(startPoint.x + offset, startPoint.y);
	CGPoint controlPoint2 = CGPointMake(endPoint.x - offset, endPoint.y);
	
	[self addCurveToPoint:endPoint 
			controlPoint1:controlPoint1
			controlPoint2:controlPoint2];
}

- (void)addNaturalCurveToPoint:(CGPoint)endPoint
{
	CGPoint startPoint = self.currentPoint;
	CGFloat midX = floor((endPoint.x + startPoint.x) / 2);
	[self addCurveToPoint:endPoint controlPointOffset:midX - startPoint.x];
}

@end
