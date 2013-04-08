//
//  AAViewRecyclerDelegate.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAViewEditing.h"
#import "AAViewSelecting.h"

@protocol AAViewRecycling <AAViewEditing, AAViewSelecting>

@end

@class AAViewRecycler;

@protocol AAViewRecyclerDelegate <NSObject>

- (UIView <AAViewRecycling> *)unusedViewForViewRecycler:(AAViewRecycler *)someViewRecycler; //adding a new view to this recycler's pool
- (BOOL)visibilityForKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler; //checking to see if this view should be visible or cached
- (CGRect)rectForViewWithKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler;
- (UIView *)superviewForViewWithKey:(id)key viewRecycler:(AAViewRecycler *)someViewRecycler;

- (void)viewRecycler:(AAViewRecycler *)someViewReuseController didLoadView:(UIView <AAViewEditing> *)view withKey:(id)key;

@optional

- (void)viewRecycler:(AAViewRecycler *)someViewReuseController selectViewWithKey:(id)key selected:(BOOL)isSelected;

@end
