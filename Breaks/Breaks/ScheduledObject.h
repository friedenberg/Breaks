//
//  ScheduledObject.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ScheduleViewDataTypes.h"
#import "NSDate+ScheduleViewDateAdditions.h"


extern NSString *NSStringFromNSUInteger100Time(NSUInteger hundredsTime);
extern NSString *NSStringFromNSUInteger60Time(NSUInteger sixtiesTime);

@interface ScheduledObject : NSManagedObject <ScheduleViewObject>

@property (nonatomic, retain, readwrite) NSDate *start;
@property (nonatomic, retain, readwrite) NSDate *end;
@property (nonatomic) NSTimeInterval duration;

- (BOOL)containsDate:(NSDate *)date;

@end