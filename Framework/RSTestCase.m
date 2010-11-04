//
//  RSTestCase.m
//  RSCommonLib
//
//  Created by daniel on 8/21/09.
//  Copyright 2009 Red Sweater Software. All rights reserved.
//
//	You are granted the right to copy and use this code under the MIT license. See License.txt for more.
//

#import "RSTestCase.h"

@implementation RSTestCase

- (void) tearDown
{
	// If we created a temporary folder for our testing purposes, delete it now
	if (mTemporaryFolder != nil)
	{
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_5
		(void) [[NSFileManager defaultManager] removeItemAtPath:mTemporaryFolder error:nil];
#else
		(void) [[NSFileManager defaultManager] removeFileAtPath:mTemporaryFolder handler:nil];
#endif		
		[mTemporaryFolder release];
		mTemporaryFolder = nil;
	}
	
	[super tearDown];
}

- (void) dealloc
{
	[mTemporaryFolder release];
	[super dealloc];
}

- (NSString *) uniqueIdentifierString
{
	NSString *uniqueIDString;

	CFUUIDRef cfUUIDObject = CFUUIDCreate(kCFAllocatorDefault);	
	uniqueIDString = (NSString *) CFUUIDCreateString(kCFAllocatorDefault, cfUUIDObject);
	CFRelease(cfUUIDObject);
	
	return [uniqueIDString autorelease];
}

- (BOOL) simpleCreateDirectoryAtPath:(NSString*)thePath withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary*)attributes
{
#if defined(MAC_OS_X_VERSION_10_5) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_5
	return [[NSFileManager defaultManager] createDirectoryAtPath:thePath withIntermediateDirectories:createIntermediates attributes:attributes error:nil];
#else
	BOOL success = YES;
	
	if (createIntermediates == YES)
	{
		NSMutableArray* missingParents = [NSMutableArray array];
		NSString* missingParent = thePath;
		while ([[NSFileManager defaultManager] fileExistsAtPath:missingParent] == NO)
		{
			[missingParents insertObject:missingParent atIndex:0];
			missingParent = [missingParent stringByDeletingLastPathComponent];
			if (([missingParent length] == 0) || ([missingParent isEqualToString:@"/"]))
			{
				break;
			}
		}

		NSEnumerator* missingEnum = [missingParents objectEnumerator];
		while (missingParent = [missingEnum nextObject])
		{
			success = [[NSFileManager defaultManager] createDirectoryAtPath:missingParent attributes:attributes];
			if (success == NO)
			{
				break;
			}
		}
	}
	else
	{
		success = [[NSFileManager defaultManager] createDirectoryAtPath:thePath attributes:nil];
	}	
	return success;	
#endif	
}

- (BOOL) simpleCreateDirectoryAtPath:(NSString*)thePath withIntermediateDirectories:(BOOL)createIntermediates
{
	return [self simpleCreateDirectoryAtPath:thePath withIntermediateDirectories:createIntermediates attributes:nil];
}

- (BOOL) simpleCreateDirectoryAtPath:(NSString*)thePath
{
	return [self simpleCreateDirectoryAtPath:thePath withIntermediateDirectories:YES];
}

- (NSString*) pathToTemporaryFolder
{
	if (mTemporaryFolder == nil)
	{
		// Guard against possibility for NSTemporaryDirectory to return nil
		NSString* tempFolderParent = NSTemporaryDirectory();
		if (tempFolderParent == nil) tempFolderParent = @"/tmp/";
		
		NSString* testFolderName = [NSString stringWithFormat:@"%@-%@", NSStringFromClass([self class]), [self uniqueIdentifierString]];
		NSString* testFileStoragePath = [tempFolderParent stringByAppendingPathComponent:testFolderName];
		[self simpleCreateDirectoryAtPath:testFileStoragePath];
		mTemporaryFolder = [testFileStoragePath retain];
	}
	
	return mTemporaryFolder;
}

- (NSString*) pathForTestInputs
{
	return [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"TestInputs"];
}

- (NSString*) pathForTestInputFilename:(NSString*)filename
{
	NSString* thePath = [[self pathForTestInputs] stringByAppendingPathComponent:filename];
	STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:thePath], @"Should have an expected test input file.");
	return thePath;
}

- (NSString*) stringFromTestInputFilename:(NSString*)filename
{
	return [NSString stringWithContentsOfFile:[self pathForTestInputFilename:filename] encoding:NSUTF8StringEncoding error:nil];
}

- (NSData*) dataFromTestInputFilename:(NSString*)filename
{
	NSData* testData = [NSData dataWithContentsOfFile:[self pathForTestInputFilename:filename]];
	STAssertNotNil(testData, @"Should have vaild data from expected test input file.");
	return testData;	
}

@end
