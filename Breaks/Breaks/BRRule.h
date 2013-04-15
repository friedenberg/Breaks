//
//  BRSectionZoneRule.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/8/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRZone;

@interface BRRule : NSManagedObject

@property (nonatomic, retain) BRZone *sectionZone;

@end
