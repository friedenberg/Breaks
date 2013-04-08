//
//  ScheduleViewDataSource.h
//  Breaks
//
//  Created by Sasha Friedenberg on 6/2/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleViewDataTypes.h"


@class ScheduleView;

@protocol ScheduleViewDataSource <NSObject>

@required

//- (NSDate *)referenceDateForScheduleView:(ScheduleView *)someScheduleView; //some arbitrary date used as a reference point for everything on the schedule

- (NSUInteger)numberOfSectionsInScheduleView:(ScheduleView *)someScheduleView;
- (NSUInteger)numberOfShiftsInSection:(NSUInteger)section inScheduleView:(ScheduleView *)someScheduleView;
- (NSUInteger)numberOfZoningsAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView;
- (NSUInteger)numberOfBreaksAtIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView;

- (id <ScheduleViewObject>)shiftObjectForIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView;
- (id <ScheduleViewObject>)zoningObjectForIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView;
- (id <ScheduleViewObject>)breakObjectForIndexPath:(NSIndexPath *)indexPath inScheduleView:(ScheduleView *)someScheduleView;

@end
