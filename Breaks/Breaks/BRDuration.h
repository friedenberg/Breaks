//
//  BRDuration.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "BRModelObjectPrimitives.h"


@class BRBreak, BRZoning, BRShift;

@interface BRDuration : NSManagedObject

@property (nonatomic, strong) NSDate * scheduledStartDate;
@property (nonatomic, strong) NSDate * scheduledEndDate;
@property (nonatomic, strong) NSDate * actualStartDate;
@property (nonatomic, strong) NSDate * actualEndDate;
@property (nonatomic) double actualDuration;
@property (nonatomic) double scheduledDuration;
@property (nonatomic, strong) BRZoning *zoning;
@property (nonatomic, strong) BRShift *shift;
@property (nonatomic, strong) BRBreak *shiftBreak;

@end
