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
#import "ScheduleView.h"

@class BRBreak, BRZoning, BRShift;

@interface BRDuration : NSManagedObject <ScheduleViewObject>

@property (nonatomic, retain) NSDate * scheduledStartDate;
@property (nonatomic, retain) NSDate * scheduledEndDate;
@property (nonatomic, retain) NSDate * actualStartDate;
@property (nonatomic, retain) NSDate * actualEndDate;
@property (nonatomic) BRTimeInterval actualDuration;
@property (nonatomic) BRTimeInterval scheduledDuration;
@property (nonatomic, retain) BRZoning *zoning;
@property (nonatomic, retain) BRShift *shift;
@property (nonatomic, retain) BRBreak *shiftBreak;

@end
