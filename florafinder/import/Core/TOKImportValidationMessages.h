//
//  TOKImportResult.h
//  TrapLines
//
//  Created by Andrew Tokeley on 12/07/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOKImportMessage.h"

@interface TOKImportValidationMessages : NSObject

-(id)init;

/*
 Returns all messages. Messages can be warnings or fatal errors.

 Warnings are for import issues like,
    - possible duplicate record

 Fatal errors include, issues like,
    - missing mandatory columns
    - errors on fields which would prevent row from being imported
    - malformed file format
 
  If there are no warnings, property returns nil.
 */
-(NSArray *)messages;

/* Returns messages of a given severity only
 */
-(NSArray *)messagesOfSeverity:(TOKImportMessageSeverity)severity;

/* Returns a user friendly summary of the import results.
 */
@property (readonly) NSString *summary;

-(void)addMessage:(TOKImportMessage *)message;
-(void)addMessages:(NSArray *)message;

-(NSInteger)numberOfLinesWithMessagesOfSeverity:(TOKImportMessageSeverity)severity;

-(BOOL)lineHasMessageOfSeverity:(TOKImportMessageSeverity)severity lineNumber:(NSInteger)lineNumber;


@end
