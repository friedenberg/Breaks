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

@property (nonatomic) BRTimeInterval type;
@property (nonatomic, retain) BRShift *shift;
@property (nonatomic, retain) BRDuration *duration;

@end
