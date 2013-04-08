//
//  AAViewSelecting.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/5/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAViewSelecting <NSObject>

@property (nonatomic) BOOL selected;
- (void)setSelected:(BOOL)value animated:(BOOL)animated;

@end
