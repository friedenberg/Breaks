//
//  UIViewReuseManager.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/22/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAViewRecyclerDelegate.h"


@interface AAViewRecycler : NSObject <AAViewEditing>
{
	id <AAViewRecyclerDelegate> __weak delegate;
	
	NSUInteger *visibleViewIndexes;
	NSMutableDictionary *visibleViews;
	NSMutableArray *cachedViews;
	
	//NSMutableDictionary *cachedReuseIdentifierKeys;
	
	//selection
	id keyForCurrentlyTouchedView;
	NSMutableSet *selectedViews;
	
	//mutation
	NSMutableSet *viewsToReload;
}

- (id)initWithDelegate:(id <AAViewRecyclerDelegate>)someObject;

@property (nonatomic, weak) id <AAViewRecyclerDelegate> delegate;
@property (weak, nonatomic, readonly) NSArray *visibleViews;

//recycling
- (void)processViewForKey:(id)key;

- (id)visibleViewForKey:(id)key;
- (id)cachedView;

- (void)setView:(UIView <AAViewRecycling> *)view forKey:(id)key;
- (void)cacheView:(UIView <AAViewRecycling> *)view forKey:(id)key;

- (void)cacheAllViews;
- (void)removeAllCachedViews;
- (void)removeAllViews;

//selection
- (BOOL)viewForKeyIsSelected:(id)key;
- (void)toggleSelectionForKey:(id)key;
- (void)clearSelection;
- (void)toggleSelectionForCurrentlyTouchedView;
- (void)refreshSelectionForCurrentlyTouchedView;
@property (nonatomic, strong) id keyForCurrentlyTouchedView;
- (id)currentlyTouchedView;

//mutation
- (void)addKeyToReload:(id)key;

@end
