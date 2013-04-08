//
//  ScheduleTableViewCell.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ScheduleViewCell.h"


@interface ScheduleViewZoningView : ScheduleViewCell
{
    UIImageView *backgroundImageView;
}

+ (UIImage *)defaultBackgroundImage;
+ (UIImage *)backgroundImageWithFillColor:(UIColor *)color;

@property (nonatomic, readonly) UIImageView *backgroundImageView;

@end
