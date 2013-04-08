//
//  Zone.h
//  Breaks
//
//  Created by Sasha Friedenberg on 5/23/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Zoning;

@interface Zone : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * hexColor;
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain) NSSet *zonings;
@end

@interface Zone (CoreDataGeneratedAccessors)

- (void)addZoningsObject:(Zoning *)value;
- (void)removeZoningsObject:(Zoning *)value;
- (void)addZonings:(NSSet *)values;
- (void)removeZonings:(NSSet *)values;

@end
