//
//  Zoning.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/23/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduledObject.h"


@class Shift, Zone;

@interface Zoning : ScheduledObject

@property (nonatomic, retain) Shift *shift;
@property (nonatomic, retain) Zone *shiftZone;

@end
