//
//  AAGraphLayerView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/17/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AAGraphLayerView.h"

@implementation AAGraphLayerView

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	self.backgroundColor = [UIColor clearColor];
}

@synthesize delegate;

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
	[self.delegate.bezierPath stroke];
}

@end
