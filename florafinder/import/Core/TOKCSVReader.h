//
//  TOKCSVReader.h
//  TrapLines
//
//  Created by Andrew Tokeley on 22/06/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"
#import "TOKCSVReaderDelegate.h"

extern NSString * const TOKCSVReaderDomain;
extern NSString * const TOKMissingColumnsErrorKey;
extern NSString * const TOKCSVValidationErrorKey;

@class TOKCSVColumnDefinition;

@interface TOKCSVReader : NSObject <CHCSVParserDelegate>

// The delegate to advise of progress of read
@property id<TOKCSVReaderDelegate> delegate;

-(id)initWithFilePath:(NSString *)filePath;
-(id)initWithFileURL:(NSURL *)fileURL;

@property NSArray *columnDefinitions;
@property (readonly) NSArray *fileContents;
@property  NSString *filePath;

-(BOOL)validateColumns:(NSError **)error;

// Parse the file
-(void)parse;

@end
