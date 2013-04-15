//
//  AAGraphLayerView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/17/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AAGraphLayerViewDelegate <NSObject>

@property (nonatomic, readonly) UIBezierPath *bezierPath;

@end

@interface AAGraphLayerView : UIView
{
	id <AAGraphLayerViewDelegate> __weak delegate;
}

@property (nonatomic, weak) id <AAGraphLayerViewDelegate> delegate;

@end
