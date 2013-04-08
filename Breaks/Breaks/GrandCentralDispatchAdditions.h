//
//  GrandCentralDispatchAdditions.h
//  Forecast
//
//  Created by Sasha Friedenberg on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef __BLOCKS__

void dispatch_main_async(dispatch_block_t block);
void dispatch_main_sync(dispatch_block_t block);

#endif