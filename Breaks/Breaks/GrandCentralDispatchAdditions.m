//
//  GrandCentralDispatchAdditions.m
//  Forecast
//
//  Created by Sasha Friedenberg on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GrandCentralDispatchAdditions.h"


#ifdef __BLOCKS__

void dispatch_main_async(dispatch_block_t block) {

	dispatch_async(dispatch_get_main_queue(), block);
	
};

void dispatch_main_sync(dispatch_block_t block) {
	
	dispatch_sync(dispatch_get_main_queue(), block);
	
};

#endif
