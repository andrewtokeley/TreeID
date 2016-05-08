//
//  TOKImportMessage.h
//  TrapLines
//
//  Created by Andrew Tokeley on 12/07/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TOKImportMessageSeverity)
{
    /**
     Warning for a line - row will still be imported
     */
    TOKImportWarning = 0,
    /**
     @brief Fatal error for a line - row will not be imported
     */
    TOKImportFatalError,
    /**
     Critical error that will prevent the whole file from being imported
     */
    TOKImportCriticalFileError,
    /**
     For information purposes only - has no effect on whether a file or line can be imported
     */
    TOKImportInformation,
};

@interface TOKImportMessage : NSObject

@property int lineNumber;
@property NSString *message;
@property TOKImportMessageSeverity severity;

/**
 @brief Nested array of child import messages
 @return NSArray of TOKImportMessage instances
 */
@property (readonly) NSArray *childimportMessages;

-(id)initWithLineNumber:(int)lineNumber message:(NSString *)message severity:(TOKImportMessageSeverity)severity;

-(id)initWithMessage:(NSString *)message severity:(TOKImportMessageSeverity)severity;

-(void)addChildImportMessage:(TOKImportMessage *)importMessage;

@end
