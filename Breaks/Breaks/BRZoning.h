//
//  BRShiftZoning.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRDuration, BRZone, BRShift;

@interface BRZoning : NSManagedObject

@property (nonatomic, retain) BRShift *shift;
@property (nonatomic, retain) BRZone *sectionZone;
@property (nonatomic, retain) BRDuration *duration;

@end
