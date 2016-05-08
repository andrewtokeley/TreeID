//
//  TOKImportMessage.m
//  TrapLines
//
//  Created by Andrew Tokeley on 12/07/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import "TOKImportMessage.h"

@interface TOKImportMessage()

@property NSMutableArray *childImportMessages;

@end

@implementation TOKImportMessage

-(id)initWithMessage:(NSString *)message severity:(TOKImportMessageSeverity)severity
{
    return [self initWithLineNumber:0 message:message severity:severity];
}

-(id)initWithLineNumber:(int)lineNumber message:(NSString *)message severity:(TOKImportMessageSeverity)severity;
{
    self = [self init];
    if (self)
    {
        _lineNumber = lineNumber;
        _message = message;
        _severity = severity;
        
        _childImportMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray *)childimportMessages
{
    return _childImportMessages;
}

-(void)addChildImportMessage:(TOKImportMessage *)importMessage
{
    [_childImportMessages addObject:importMessage];
}

-(NSString *)descriptionOfChildren
{
    NSString *result = @"";
    for (TOKImportMessage *message in self.childImportMessages)
    {
        result = [result stringByAppendingString:@"\n    -"];
        result = [result stringByAppendingString:message.description];
    }
    return result;
}

-(NSString *)description
{
    NSString *result;
    
    if (_lineNumber != 0)
    {
        result = [NSString stringWithFormat:@"Line %ld: %@", (long)_lineNumber, _message];
    }
    else
    {
        result = _message;
    }
    
    if (self.childimportMessages.count > 0)
    {
         result = [result stringByAppendingString:self.descriptionOfChildren];
    }
    return result;
}

@end
