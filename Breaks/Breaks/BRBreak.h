//
//  BRShiftBreak.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BRModelObjectPrimitives.h"


@class BRDuration, BRShift;

@interface BRBreak : NSManagedObject

@property (nonatomic) u_int16_t type;
@property (nonatomic, strong) BRShift *shift;
@property (nonatomic, strong) BRDuration *duration;

@end
