//
//  Tests_ExampleRunLoop.m
//  RSTestingKitExamples
//
//  Created by daniel on 10/31/10.
//  Copyright 2010 Red Sweater Software. All rights reserved.
//

#import "Tests_ExampleRunLoop.h"


@implementation Tests_ExampleRunLoop

- (void) myDelayedMethod
{
	// When we get called, we let the RSRunLoopWaitingTestCase infrastructure know we're done
	[self setWaitingForTestCompletion:NO];
}

- (void) testSimpleRunLoop
{
	// Contrived example, let's make sure that performSelector:withObject:afterDelay:
	// doesn't return any earlier than the we ask it to.
	
	NSTimeInterval startTime = [[NSDate date] timeIntervalSinceReferenceDate];
	
	NSTimeInterval expectedElapsedTime = 1.0;
	[self performSelector:@selector(myDelayedMethod) withObject:nil afterDelay:expectedElapsedTime];
	
	[self waitForRunLoopTestCompletion];
	
	NSTimeInterval endTime = [[NSDate date] timeIntervalSinceReferenceDate];	
	NSTimeInterval elapsedTime = (endTime - startTime);
	
	STAssertEqualsWithAccuracy(elapsedTime, expectedElapsedTime, 0.01,
						@"Expected elapsed time around %f, got %f", expectedElapsedTime, elapsedTime);	
}

@end
