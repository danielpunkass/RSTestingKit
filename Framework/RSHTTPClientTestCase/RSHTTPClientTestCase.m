//
//  RSHTTPClientTestCase.m
//  MarsEdit
//
//  Created by Daniel Jalkut on 3/20/09.
//  Copyright 2009 Red Sweater Software. All rights reserved.
//
//	You are granted the right to copy and use this code under the MIT license. See License.txt for more.
//

#import "RSHTTPClientTestCase.h"
#import "GTMHTTPServer.h"

@implementation RSHTTPClientTestCase

- (void) setUp
{
	[super setUp];
	
	mTestServer = [[GTMHTTPServer alloc] initWithDelegate:self];
	[mTestServer setPort:0];
	NSError* serverErr = nil;
	[mTestServer start:&serverErr];
}

- (void) tearDown
{
	[mTestServer stop];
	[mTestServer release];
	
	[super tearDown];
}

- (NSURL*) serverURLForHTTPTestNamed:(NSString*)testName
{
	NSString* urlString = [NSString stringWithFormat:@"http://localhost:%d/%@", [[self testServer] port], testName];
	return [NSURL URLWithString:urlString];
}

- (NSString*) testNameFromServerURL:(NSURL*)theTestURL
{
	return [[theTestURL path] substringFromIndex:1];	// the path minus the leading "/"
}

//  testServer 
- (GTMHTTPServer *) testServer
{
    return mTestServer; 
}

- (void) setTestServer: (GTMHTTPServer *) theTestServer
{
    if (mTestServer != theTestServer)
    {
        [mTestServer release];
        mTestServer = [theTestServer retain];
    }
}

// the default test-server delegate attempts to dispatch to a server response method named appropriately for the test name
- (GTMHTTPResponseMessage *)httpServer:(GTMHTTPServer *)server handleRequest:(GTMHTTPRequestMessage *)request
{
	NSString* thisTestName = [self testNameFromServerURL:[request URL]];
	NSString* requestResponseMethodName = [NSString stringWithFormat:@"responseForTestRequest_%@:", thisTestName];
	SEL responseSelector = NSSelectorFromString(requestResponseMethodName);
	
	// If we (i.e. the specific test subclass) respond to the method, use it. Otherwise we fake a 404 response.
	if ([self respondsToSelector:responseSelector])
	{
		return [self performSelector:responseSelector withObject:request];
	}
	else
	{
		return [GTMHTTPResponseMessage responseWithBody:[@"Test URL not handled" dataUsingEncoding:NSUTF8StringEncoding] contentType:@"text/plain" statusCode:404];
	}
}

@end
