//
//  Tests_ExampleHTTP.h
//  RSTestingKitExamples
//
//  Created by daniel on 10/31/10.
//  Copyright 2010 Red Sweater Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RSTestingKit/RSTestingKit.h>

@interface Tests_ExampleHTTP : RSHTTPClientTestCase
{
	NSMutableData* mCurrentRequestResponseData;
}

@end
