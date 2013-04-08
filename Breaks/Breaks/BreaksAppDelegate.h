//
//  AppDelegate.h
//  Breaks
//
//  Created by Sasha Friedenberg on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AAKit/AAKit.h>


@interface BreaksAppDelegate : UIResponder <UIApplicationDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) AACoreDataController *coreDataController;

- (NSURL *)applicationDocumentsDirectory;

@end

extern BreaksAppDelegate *AppDelegate(void);