//
//  UIViewReuseManager.m
//  Breaks
//
//  Created by Sasha Friedenberg on 5/22/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AAViewRecycler.h"

@implementation AAViewRecycler

- (id)initWithDelegate:(id <AAViewRecyclerDelegate>)someObject
{
	if (self = [super init])
	{
		self.delegate = someObject;
		
		visibleViews = [NSMutableDictionary new];
		
		cachedViews = [NSMutableArray new];
		
		//cachedReuseIdentifierKeys = [NSMutableDictionary new];
		selectedViews = [NSMutableSet new];
	}
	
	return self;
}

@synthesize delegate, editing;

- (void)setEditing:(BOOL)value
{
	[self setEditing:value animated:NO];
}

- (void)setEditing:(BOOL)value animated:(BOOL)animated
{
	editing = value;
	for (id view in [visibleViews allValues]) [view setEditing:editing animated:animated];
	[self clearSelection];
}

- (void)processViewForKey:(id)key
{
	UIView <AAViewRecycling> *view = [self visibleViewForKey:key];
	BOOL isVisible = [self.delegate visibilityForKey:key viewRecycler:self];
	BOOL wasVisible = view != nil;
	
	if (isVisible)
	{
		if (!view) view = [self cachedView];
		if (!view) view = [self.delegate unusedViewForViewRecycler:self];
		
		if ([viewsToReload containsObject:key] || !wasVisible) [self setView:view forKey:key];
		else view.frame = [self.delegate rectForViewWithKey:key viewRecycler:self];
	}
	else if (wasVisible) [self cacheView:view forKey:key];
}

- (NSArray *)visibleViews
{
	return [visibleViews allValues];
}

- (id)visibleViewForKey:(id)key
{
	return [visibleViews objectForKey:key];
}

- (id)cachedView
{
	return [cachedViews lastObject];
}

- (void)setView:(UIView <AAViewRecycling> *)view forKey:(id)key
{
	view.editing = self.editing;
	view.selected = [selectedViews containsObject:key];
	[self.delegate viewRecycler:self didLoadView:view withKey:key];
	
	view.frame = [self.delegate rectForViewWithKey:key viewRecycler:self];
	
	[[self.delegate superviewForViewWithKey:key viewRecycler:self] addSubview:view];
	[visibleViews setObject:view forKey:key];
	[cachedViews removeObject:view];
}

- (void)cacheView:(UIView <AAViewRecycling> *)view forKey:(id)key
{
	[cachedViews addObject:view];
	[visibleViews removeObjectForKey:key];
	[view removeFromSuperview];
}

- (void)cacheAllViews
{
	[cachedViews addObjectsFromArray:[visibleViews allValues]];
	[visibleViews removeAllObjects];
	[viewsToReload removeAllObjects];
}

- (void)removeAllCachedViews
{
	[cachedViews removeAllObjects];
}

- (void)removeAllViews
{
	[visibleViews removeAllObjects];
	[cachedViews removeAllObjects];
	[viewsToReload removeAllObjects];
}

#pragma - mark selection

- (BOOL)viewForKeyIsSelected:(id)key
{
	return [selectedViews containsObject:key];
}

- (void)toggleSelectionForKey:(id)key
{
	if (!key) return;
	BOOL isSelected = [selectedViews containsObject:key];
	
	if (isSelected) [selectedViews removeObject:key];
	else [selectedViews addObject:key];
	
	[self.delegate viewRecycler:self selectViewWithKey:key selected:!isSelected];
}

- (void)clearSelection
{
	NSArray *deselectedViews = [selectedViews allObjects];
	[selectedViews removeAllObjects];
	
	[[visibleViews objectsForKeys:deselectedViews notFoundMarker:[NSNull null]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		if (obj != [NSNull null])
		{
			UIView <AAViewEditing> *view = obj;
			id key = [deselectedViews objectAtIndex:idx];
			
			[self.delegate viewRecycler:self didLoadView:view withKey:key];
		}
	}];
}

@synthesize keyForCurrentlyTouchedView;

- (id)currentlyTouchedView
{
	return [self visibleViewForKey:self.keyForCurrentlyTouchedView];
}

- (void)refreshSelectionForCurrentlyTouchedView
{
	BOOL isSelected = [selectedViews containsObject:keyForCurrentlyTouchedView];
	
	if ([delegate respondsToSelector:@selector(viewRecycler:selectViewWithKey:selected:)])
		[delegate viewRecycler:self selectViewWithKey:keyForCurrentlyTouchedView selected:isSelected];
}

- (void)toggleSelectionForCurrentlyTouchedView
{
	[self toggleSelectionForKey:self.keyForCurrentlyTouchedView];
}

#pragma mark - mutation

- (void)addKeyToReload:(id)key
{
	[viewsToReload addObject:key];
}


@end
