//
//  NSObject+Error.h
//  Dispatch
//
//  Created by Sasha Friedenberg on 10/4/10.
//  Copyright 2010 Anodized Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (AACheckingForErrors)

@property (nonatomic, readonly) BOOL isError;

- (void)setup;

@end

@interface NSError (Logging)

- (void)log;

@end