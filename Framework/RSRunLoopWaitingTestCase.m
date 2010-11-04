//
//  RSRunLoopWaitingTestCase.m
//  RSCommon
//
//  Created by Daniel Jalkut on 9/10/08.
//  Copyright 2008 Red Sweater Software. All rights reserved.
//
//	You are granted the right to copy and use this code under the MIT license. See License.txt for more.
//

#import <RSTestingKit/RSRunLoopWaitingTestCase.h>

// Could be parameterized like the completion timeout but I haven't found a need yet
static CGFloat kRunLoopIterationTimerInterval = 0.2;

@implementation RSRunLoopWaitingTestCase

- (void) commonInit
{
	// Default to timing out long tests after 10 seconds
	mTestCompletionTimeout = 10.0;
}

- (id) initWithInvocation:(NSInvocation*)theInvocation
{
	self = [super initWithInvocation:theInvocation];
	if (self != nil)
	{
		[self commonInit];
	}
	return self;
}

- (id) initWithSelector:(SEL)theSelector
{
	self = [super initWithSelector:theSelector];
	if (self != nil)
	{
		[self commonInit];
	}
	return self;
}

- (void) dealloc
{
	[mTimeoutFailureContextString release];
	
	[super dealloc];
}

//  waitingForTestCompletion 
- (BOOL) waitingForTestCompletion
{
    return mWaitingForTestCompletion;
}

- (void) setWaitingForTestCompletion: (BOOL) flag
{
    mWaitingForTestCompletion = flag;
}

//  testCompletionTimeout 
- (NSTimeInterval) testCompletionTimeout
{
    return mTestCompletionTimeout;
}

- (void) setTestCompletionTimeout: (NSTimeInterval) theTestCompletionTimeout
{
    mTestCompletionTimeout = theTestCompletionTimeout;
}

//  timeoutFailureContextString 
- (NSString *) timeoutFailureContextString
{
    return mTimeoutFailureContextString; 
}

- (void) setTimeoutFailureContextString: (NSString *) theTimeoutFailureContextString
{
    if (mTimeoutFailureContextString != theTimeoutFailureContextString)
    {
        [mTimeoutFailureContextString release];
        mTimeoutFailureContextString = [theTimeoutFailureContextString retain];
    }
}

- (void) waitForRunLoopTestCompletion
{
	[self setWaitingForTestCompletion:YES];
	
	// Wait for the download to finish
	NSTimeInterval startTime = [[NSDate date] timeIntervalSinceReferenceDate];
	while ([self waitingForTestCompletion] == YES)
	{		
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kRunLoopIterationTimerInterval]];
		
		// Don't let the download take longer than we're allowed
		NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceReferenceDate] - startTime;
		if (elapsedTime > (mTestCompletionTimeout)) 
		{
			NSString* failContext = [self timeoutFailureContextString];
			if (failContext == nil)
			{
				failContext = @"Timed out trying to perform test.";
			}
			NSString* testFailString = [NSString stringWithFormat:@"%@ %@", failContext, @"DCJ - Get more info about the running test in here?"];
			STAssertTrue(0, testFailString);
			[self setWaitingForTestCompletion:NO];
			break;
		}
	}
}

@end
