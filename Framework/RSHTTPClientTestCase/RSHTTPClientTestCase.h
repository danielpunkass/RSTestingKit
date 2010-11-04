//
//  RSHTTPClientTestCase.h
//  MarsEdit
//
//	Provides common testing infrastructure to test cases where an artificial
//	HTTP server is run from within the test case, in order to accept expected 
//	connections and to serve expected results.
//
//  Created by Daniel Jalkut on 3/20/09.
//  Copyright 2009 Red Sweater Software. All rights reserved.
//
//	You are granted the right to copy and use this code under the MIT license. See License.txt for more.
//

#import <RSTestingKit/RSRunLoopWaitingTestCase.h>

@class GTMHTTPServer;
@class GTMHTTPRequestMessage;
@class GTMHTTPResponseMessage;

@interface RSHTTPClientTestCase : RSRunLoopWaitingTestCase
{
	GTMHTTPServer* mTestServer;
}

// For subclass access, mainly
- (GTMHTTPServer *) testServer;
- (void) setTestServer: (GTMHTTPServer *) theTestServer;

// These facilitate no-nonsense generation of test URLs that convey 
// the desired test behavior from the client to the "server". Essentially
// just an easy way of encoding the test by name into a URL that will get 
// any HTTP request from the client directed to the test server we are running.

- (NSURL*) serverURLForHTTPTestNamed:(NSString*)testName;
- (NSString*) testNameFromServerURL:(NSURL*)theTestURL;

// Subclasses should  implement this GTMHTTPServer delegate method only if they 
// need to customize behavior of the HTTP server beyond what we provide by default.
//
// By default, you don't need to implement this. Just implement a method for each of your
// named tests which conforms to the naming convention, e.g., for a test "basic":
//
//		- (GTMHTTPResponseMessage *) responseForTestRequest_basic:(GTMHTTPRequestMessage *)request;
//
// Using this facility makes it easier to let your test server response conditions live in methods
// very close to the test client code.
//
- (GTMHTTPResponseMessage *)httpServer:(GTMHTTPServer *)server handleRequest:(GTMHTTPRequestMessage *)request;

@end
