//
//  Employee.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/23/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Shift;

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Shift *shift;

@end
