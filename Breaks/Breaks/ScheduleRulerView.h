//
//  ScheduleRulerView.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleView;

@interface ScheduleRulerView : UIView
{
	ScheduleView *superTable;
}

- (id)initWithTable:(ScheduleView *)someTable;

@end
