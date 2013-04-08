//
//  AAOperation.h
//  Dispatch
//
//  Created by Sasha Friedenberg on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^AAOperationCompletionBlock)(id response);

@interface AAOperation : NSOperation 
{
@protected
	NSThread *callingThread;
	NSError *incomingError;
	NSError *error;
}

@property (nonatomic, readonly) NSThread *callingThread;
@property (nonatomic, retain) NSError *error;

- (void)commitIncomingError;
- (void)commitError:(NSError *)anError;

- (void)addDependencies:(NSSet *)dependencies;

@end
