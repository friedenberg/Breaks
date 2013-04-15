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

@property (nonatomic, strong) BRShift *shift;
@property (nonatomic, strong) BRZone *sectionZone;
@property (nonatomic, strong) BRDuration *duration;

@end
