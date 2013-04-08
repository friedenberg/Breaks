//
//  AAEditing.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAViewEditing <NSObject>

@property (nonatomic) BOOL editing;
- (void)setEditing:(BOOL)value animated:(BOOL)animated;

@end
