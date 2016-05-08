//
//  TOKImportResult.m
//  TrapLines
//
//  Created by Andrew Tokeley on 12/07/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import "TOKImportValidationMessages.h"

@interface TOKImportValidationMessages()

@property NSMutableArray *messagesInternal;

@property NSMutableDictionary *lineCounts;

@end

@implementation TOKImportValidationMessages

-(id)init
{
    self = [super init];
    if (self)
    {
        _lineCounts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSArray *)messages
{
    return _messagesInternal;
}

-(NSArray *)messagesOfSeverity:(TOKImportMessageSeverity)severity
{
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject severity] == severity;
    }];

    NSArray *result = [_messagesInternal filteredArrayUsingPredicate:filter];
    
    return result != nil ? result : [[NSArray alloc] init];
}

-(BOOL)lineHasMessageOfSeverity:(TOKImportMessageSeverity)severity lineNumber:(NSInteger)lineNumber
{
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        TOKImportMessage *message = evaluatedObject;
        
        return message.severity == severity && message.lineNumber == lineNumber;
    }];
    
    //NSLog(_messagesInternal[0].lineNumber)
    
    NSArray *result = [_messagesInternal filteredArrayUsingPredicate:filter];
    
    return result != nil ? result.count : 0;
}

-(void)addMessage:(TOKImportMessage *)message
{
    if (!_messagesInternal)
    {
        _messagesInternal = [[NSMutableArray alloc] init];
    }
    
    [_messagesInternal addObject:message];
    
    //[self incrementCountsForMessage:(TOKImportMessage *)message];
}

-(void)addMessages:(NSArray *)messages
{
    for (TOKImportMessage *message in messages)
    {
        if (message)
        {
            [self addMessage:message];
        }
    }
}

//-(void)incrementCountsForMessage:(TOKImportMessage *)message
//{
//    // Get the key for this message severity
//    NSString *lineKey = [NSString stringWithFormat:@"%d", message.severity];
//    
//    // See if there's a count for this key already
//    NSNumber *currentCount = [self.severityCounts objectForKey:lineKey];
//    
//    if (currentCount)
//    {
//        count = [currentCount integerValue] + 1;
//    }
//    
//    // Set the count
//    [self.lineCounts setObject:[NSNumber numberWithInt:count] forKey:lineKey];
//}

-(NSInteger)numberOfLinesWithMessagesOfSeverity:(TOKImportMessageSeverity)severity
{
    NSMutableArray *uniqueLines = [[NSMutableArray alloc] init];
    for (TOKImportMessage *message in [self messagesOfSeverity:severity])
    {
        if (message.lineNumber !=NSNotFound)
        {
            NSNumber *lineNumberAsObject = [NSNumber numberWithInt:(int)message.lineNumber];
            if (![uniqueLines containsObject:lineNumberAsObject])
            {
                [uniqueLines addObject:lineNumberAsObject];
            }
        }
    }
    return uniqueLines.count;
}

-(NSString *)description
{
    return [self summary];
}

-(NSString *)summary
{
    NSString *summary = @"";
    
    NSArray *fatalErrors = [self messagesOfSeverity:TOKImportFatalError];
    NSArray *warnings = [self messagesOfSeverity:TOKImportWarning];
    NSArray *information = [self messagesOfSeverity:TOKImportInformation];
    NSArray *critcal = [self messagesOfSeverity:TOKImportCriticalFileError];
    
    if (critcal.count > 0)
    {
        summary = [summary stringByAppendingString:@"Critical errors"];
        summary = [summary stringByAppendingString:[self writeImportMessages:critcal]];
    }
    
    if (information.count > 0)
    {
        summary = [summary stringByAppendingString:@"General information"];
        summary = [summary stringByAppendingString:[self writeImportMessages:information]];
    }
    
    if (fatalErrors.count > 0)
    {
        summary = [summary stringByAppendingString:[NSString stringWithFormat:@"%lu fatal errors,", (unsigned long)fatalErrors.count]];
        summary = [summary stringByAppendingString:[self writeImportMessages:fatalErrors]];
    }
    
    if (warnings.count > 0)
    {
        summary = [summary stringByAppendingString:[NSString stringWithFormat:@"%lu warnings,", (unsigned long)warnings.count]];
        summary = [summary stringByAppendingString:[self writeImportMessages:warnings]];
    }
    
    return summary;
}

-(NSString *)writeImportMessages:(NSArray *)importMessages
{
    NSString *result = @"";
    
    for (TOKImportMessage *message in importMessages)
    {
        if ([message isKindOfClass:[TOKImportMessage class]])
        {
            result = [result stringByAppendingString:@"\n"];
            result = [result stringByAppendingString:[NSString stringWithFormat:@"  - %@",message.description]];
            if (message == [importMessages lastObject])
            {
                result = [result stringByAppendingString:@"\n\n"];
            }
        }
    }
    return result;
}
@end
