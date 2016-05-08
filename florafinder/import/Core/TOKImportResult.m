//
//  TOKImportResult.m
//  TrapLines
//
//  Created by Andrew Tokeley on 14/07/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import "TOKImportResult.h"

@implementation TOKImportResult

-(TOKImportStatus)status
{
    TOKImportStatus returnValue = TOKImportStatusUnknown;

    NSInteger fatalLines = [self.messages numberOfLinesWithMessagesOfSeverity:TOKImportFatalError];
    
    // If there are any critical file errors then the import has/will fail
    if ([self.messages messagesOfSeverity:TOKImportCriticalFileError].count > 0)
    {
        returnValue = TOKImportStatusFail;
    }
    // If there are no lines with fatal errors then it's a complete success
    else if (fatalLines == 0)
    {
        returnValue = TOKImportStatusSuccess;
    }
    // If all the lines are fatal then it's a fail
    else if (fatalLines == self.rawData.count - 1) // rawData contains header
    {
        returnValue = TOKImportStatusFail;
    }
    else
    {
        returnValue = TOKImportStatusPartialSuccess;
    }
    return returnValue;
}

-(NSUInteger)validLinesCount
{    NSInteger failedRows = [self.messages numberOfLinesWithMessagesOfSeverity:TOKImportFatalError];
    return self.rawData.count - 1 - failedRows;
}

@end
