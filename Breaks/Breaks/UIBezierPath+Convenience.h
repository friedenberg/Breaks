//
//  UIBezierPath+Convenience.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/17/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Convenience)

- (void)addCurveToPoint:(CGPoint)endPoint controlPointOffset:(CGFloat)offset;
- (void)addNaturalCurveToPoint:(CGPoint)point;

@end
