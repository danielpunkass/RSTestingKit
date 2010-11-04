//
//  RSRunLoopWaitingTestCase.h
//  RSCommon
//
//  Created by Daniel Jalkut on 9/10/08.
//  Copyright 2008 Red Sweater Software. All rights reserved.
//
//	You are granted the right to copy and use this code under the MIT license. See License.txt for more.
//

//	Provides common testing infrastructure to test cases where real time must be 
//	spent running the runloop and waiting for a conclusion flag to turn true.
//
//  The "test" methods can for instance:
//
//  	[self setTimeoutFailureContextString:@"Waiting for Godot"];
//		[self performWaitingForGodotTest];
//		[self waitForRunLoopTestCompletion];
//
//	The "performWaitingForGodotTest" spawn a runloop-driven whose callback promises to 
//	to call [self setWaitingForTestCompletion:NO];
//

#import <RSTestingKit/RSTestCase.h>

@interface RSRunLoopWaitingTestCase : RSTestCase
{
	BOOL mWaitingForTestCompletion;
	
	NSTimeInterval mTestCompletionTimeout;

	// What error string should we communicate when we fail from timeout?
	NSString* mTimeoutFailureContextString;
}

// How long will we run the loop before giving up and failing the test?
- (NSTimeInterval) testCompletionTimeout;
- (void) setTestCompletionTimeout: (NSTimeInterval) theTestCompletionTimeout;

- (NSString *) timeoutFailureContextString;
- (void) setTimeoutFailureContextString: (NSString *) theTimeoutFailureContextString;

- (void) waitForRunLoopTestCompletion;

- (BOOL) waitingForTestCompletion;
- (void) setWaitingForTestCompletion: (BOOL) flag;

@end
