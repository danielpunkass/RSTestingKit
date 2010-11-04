//
//  Tests_ExampleInput.m
//  RSTestingKitExamples
//
//  Created by daniel on 10/31/10.
//  Copyright 2010 Red Sweater Software. All rights reserved.
//

#import "Tests_ExampleInput.h"

@implementation Tests_ExampleInput

- (void) testSimpleInput
{
	// Normally you would use the input facility of RSTestCase to e.g. 
	// provide some complicated data like an XML file or an image to code 
	// that you are trying to test. IN this example we'll just test the 
	// ability of NSImage to load an image and return the expected image
	// dimensions.
	
	NSData* imageData = [self dataFromTestInputFilename:@"TestImage.png"];

	// We don't particularly need to test that imageData != nil, because 
	// dataFromTestInputFilename will itself raise a test failure if the file is not there.
	
	// Create the image, check for non-nil-ness, then check for the expected dimensions
	NSImage* testImage = [[NSImage alloc] initWithData:imageData];
	STAssertNotNil(testImage, @"Test image input should have produced a good image object.");
	
	NSString* thisImageSizeString = NSStringFromSize([testImage size]);
	NSString* expectedImageSizeString = @"{550, 550}";
	STAssertEqualObjects(thisImageSizeString, expectedImageSizeString, @"Expected %@ size, got %@", expectedImageSizeString, thisImageSizeString);
}

@end
