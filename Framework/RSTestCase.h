//
//  RSTestCase.h
//  RSCommonLib
//
//  Created by daniel on 8/21/09.
//  Copyright 2009 Red Sweater Software. All rights reserved.
//
//	You are granted the right to copy and use this code under the MIT license. See License.txt for more.
//

#import <SenTestingKit/SenTestingKit.h>

@interface RSTestCase : SenTestCase
{
	NSString* mTemporaryFolder;
}

// A folder that is appropriate for sandbox test file writing/reading. Will be removed when tests are completed.
- (NSString*) pathToTemporaryFolder;

// Returns the path to the folder from wihich test input files will be loaded. By default, 
// these are located in the test bundle's resources folder, inside a folder named "TestInputs"
- (NSString*) pathForTestInputs;

// Returns a path to the test input file of a given name. 
- (NSString*) pathForTestInputFilename:(NSString*)filename;
- (NSString*) stringFromTestInputFilename:(NSString*)filename;
- (NSData*) dataFromTestInputFilename:(NSString*)filename;

@end

// Add some convenience macros of our own

#define RSAssertMatchingStrings(actualString, expectedString, comment) \
	do { \
		STAssertTrue([actualString isEqualToString:expectedString], @"%@: expected %@ got %@", comment, expectedString, actualString);\
	} while (0)
	
#define RSAssertFileExists(filePath, description, ...) \
do { \
    @try {\
        id filePathValue = (filePath); \
		if ([[NSFileManager defaultManager] fileExistsAtPath:filePathValue] == NO) { \
            [self failWithException:([NSException failureInFile:[NSString stringWithUTF8String:__FILE__] \
                                                         atLine:__LINE__ \
                                                withDescription:@"%@", [@"File does not exist: " stringByAppendingString:STComposeString(description, ##__VA_ARGS__)]])]; \
		} \
    }\
    @catch (id anException) {\
        [self failWithException:([NSException failureInRaise:[NSString stringWithFormat:@"fileExistsAtPath:(%s)", #filePath] \
                                                  exception:anException \
                                                     inFile:[NSString stringWithUTF8String:__FILE__] \
                                                     atLine:__LINE__ \
                                            withDescription:@"%@", STComposeString(description, ##__VA_ARGS__)])]; \
    }\
} while(0)

#define RSAssertFileDoesNotExist(filePath, description, ...) \
do { \
    @try {\
        id filePathValue = (filePath); \
		if ([[NSFileManager defaultManager] fileExistsAtPath:filePathValue] == YES) { \
            [self failWithException:([NSException failureInFile:[NSString stringWithUTF8String:__FILE__] \
                                                         atLine:__LINE__ \
                                                withDescription:@"%@", [@"File does exist: " stringByAppendingString:STComposeString(description, ##__VA_ARGS__)]])]; \
		} \
    }\
    @catch (id anException) {\
        [self failWithException:([NSException failureInRaise:[NSString stringWithFormat:@"fileExistsAtPath:(%s)", #filePath] \
                                                  exception:anException \
                                                     inFile:[NSString stringWithUTF8String:__FILE__] \
                                                     atLine:__LINE__ \
                                            withDescription:@"%@", STComposeString(description, ##__VA_ARGS__)])]; \
    }\
} while(0)

