//
//  BRTouchForwardingView.m
//  Breaks
//
//  Created by Sasha Friedenberg on 4/22/13.
//
//

#import "BRTouchForwardingView.h"

#import "BRScheduleView_Internal.h"


@implementation BRTouchForwardingView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_scheduleView touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_scheduleView touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_scheduleView touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_scheduleView touchesCancelled:touches withEvent:event];
}

@end
