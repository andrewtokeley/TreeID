//
//  TOKCSVParser.m
//  TrapLines
//
//  Created by Andrew Tokeley on 30/06/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import "TOKCSVParser.h"
#import "TOKCSVColumnDefinition.h"
#import "TOKRowField.h"

#define COMMA ','

NSString * const TOKValidationErrorKey = @"TOKValidationErrorKey";

@interface TOKCSVParser()

// URL of the file being imported from or exported to
@property NSURL *fileURL;

// For imports, the raw contents of the file
@property (readonly) NSArray *fileContentsRaw;

// For imports the column headings of the file
@property (readonly) NSArray *fileColumnHeadings;

// Third party parsing engine
@property CHCSVParser *parserEngine;

@property NSInteger blankRowCount;

@end

@implementation TOKCSVParser

@synthesize fileContentsRaw = _fileContentsRaw;
@synthesize validationMessages = _validationMessages;
@synthesize results = _results;
@synthesize columnDefinitions = _columnDefinitions;
@synthesize fileColumnHeadings = _fileColumnHeadings;
@synthesize importSummaryMessages = _importSummaryMessages;

-(id)init
{
    return [self initWithFileURL:nil];
}

-(id)initWithFileURL:(NSURL *)fileURL
{
    self = [super init];
    if (self)
    {
        self.fileURL = fileURL;
        self.parserEngine.delegate = self;
    }
    return self;
}

-(void)resetState
{
    _fileColumnHeadings = nil;
    _fileContentsRaw = nil;
    _validationMessages = nil;
    _results = nil;
    _importSummaryMessages = nil;
    _blankRowCount = 0;
}

#pragma mark - File

-(NSArray *)fileContentsRaw
{
    if (!_fileContentsRaw)
    {
        CHCSVParserOptions options =
            CHCSVParserOptionsRecognizesBackslashesAsEscapes |
            CHCSVParserOptionsSanitizesFields |
            CHCSVParserOptionsRecognizesComments |
            CHCSVParserOptionsStripsLeadingAndTrailingWhitespace;
        
        _fileContentsRaw = [NSArray arrayWithContentsOfCSVFile:[self.fileURL relativePath] options:options delimiter:COMMA];
    }
    return _fileContentsRaw;
}

-(NSArray *)fileColumnHeadings
{
    if (!_fileColumnHeadings)
    {
        _fileColumnHeadings = [[self fileContentsRaw] firstObject];
    }
    return _fileColumnHeadings;
}

-(TOKCSVColumnDefinition *)columnDefinitionAtIndex:(NSInteger)index
{
    TOKCSVColumnDefinition *column = nil;
    
    if (self.fileColumnHeadings)
    {
        for (TOKCSVColumnDefinition *c in self.columnDefinitions)
        {
            if ([self indexOfColumnDefinition:c] == index)
            {
                column = c;
            }
        }
    }
    return column;
}

-(NSInteger)indexOfColumnDefinition:(TOKCSVColumnDefinition *)columnDefinition
{
    NSInteger result = NSNotFound;
    
    NSUInteger index = [self.fileColumnHeadings indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop){
                            NSString *heading = (NSString *)obj;
                            return [heading isEqualToString:columnDefinition.heading];
                        }];
    
    if (index != NSNotFound)
    {
        result = index;
    }

    return result;
}


#pragma mark - Results

-(NSMutableArray *)results
{
    if (!_results)
    {
        _results = [[NSMutableArray alloc] init];
    }
    return _results;
}

#pragma mark - Errors

-(TOKImportValidationMessages *)validationMessages
{
    if (!_validationMessages)
    {
        _validationMessages = [[TOKImportValidationMessages alloc] init];
    }
    return _validationMessages;
}

#pragma mark - Importing


-(void)importFile:(voidBlockWithImportResult)completionBlock
{
    if (self.fileURL)
    {
        [self importFile:self.fileURL completionBlock:completionBlock];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Must define the file to import using init or importFile:completionBlock method."];
    }
}

-(void)importFile:(NSURL *)file completionBlock:(voidBlockWithImportResult)completionBlock
{
    [self resetState];
    
    self.fileURL = file;
    
    [self checkForMandatoryColumns];
    
    // only continue if all the mandatory columns are present
    if ([self.validationMessages messagesOfSeverity:TOKImportCriticalFileError].count == 0)
    {
        [self processRowsAndSave:YES];
    }
    
    if (completionBlock)
    {
        TOKImportResult *result = [[TOKImportResult alloc] init];
        result.rawData = self.fileContentsRaw;
        result.savedData = self.results;
        result.messages = self.validationMessages.messages.count > 0 ? self.validationMessages : nil;
        completionBlock(result);
    }
}

-(void)processRowsAndSave:(BOOL)save
{
    // Transform each row (apart from the header row) according to the columnDefinitions
    for (int i=1; i<[self fileContentsRaw].count; i++)
    {
        NSDictionary *rowData;
        
        @try
        {
            NSArray *row = [[self fileContentsRaw] objectAtIndex:i];
            
            // Check for blank row
            if (row.count == 1 && self.fileColumnHeadings.count > 1)
            {
                // This is considered a blank row - ignore
                self.blankRowCount ++;
            }
            else
            {
                // check field contains a valid value
                
                rowData = [self transformRow:row recordNumber:i+1];
                
                // did this row contain any fatal errors?
                BOOL fatalErrors = [self.validationMessages lineHasMessageOfSeverity:TOKImportFatalError lineNumber:i + 1];
                
                if (rowData && !fatalErrors)
                {
                    // The implementation of saveWithRowData:recordNumber:save is defined in the subclass
                    id savedObject = [self processRowData:rowData recordNumber:i save:save];
                    
                    // We're only going to get some results if we've saved.
                    if (save)
                    {
                        // Add the result to the global results
                        [self.results addObject:savedObject];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            // Don't stop importing file, just record the fatal error for this line
            [self.validationMessages addMessage:[[TOKImportMessage alloc] initWithLineNumber:i+1 message:exception.reason severity:TOKImportFatalError]];
        }
    }
    
}

-(NSArray *)importSummaryMessages
{
    TOKImportMessage *blankRowsMessage;
    TOKImportMessage *numberRowsImportedMessage;
    
    // Add an information message describing what will be imported
    NSInteger numberNotImporting  = [self.validationMessages numberOfLinesWithMessagesOfSeverity:TOKImportFatalError] + self.blankRowCount;
    
    NSInteger totalImporting = self.fileContentsRaw.count - 1 - numberNotImporting;
    
    NSString *information = [NSString stringWithFormat:@"%d out of %d rows will be imported.", (int)totalImporting, (int)(self.fileContentsRaw.count - 1)];
    
    numberRowsImportedMessage = [[TOKImportMessage alloc] initWithMessage:information severity:TOKImportInformation];
    
    if (self.blankRowCount > 0)
    {
        blankRowsMessage = [[TOKImportMessage alloc] initWithMessage:[NSString stringWithFormat:@"%ld blank row(s) ignored", (long)self.blankRowCount] severity:TOKImportInformation];
    }
    
    if (blankRowsMessage)
        return [NSArray arrayWithObjects:numberRowsImportedMessage, blankRowsMessage, nil];
    else
        return [NSArray arrayWithObjects:numberRowsImportedMessage, nil];
}

/**
 @brief Transforms each field in the row based on the columnDefinitions
 
 @param row an NSArray of NSString values representing each row field
 @param recordNumber the row number
 
 @return An NSDictionary where the key is the column heading and the value is an instance of TOKRowField
 */
-(NSDictionary *)transformRow:(NSArray *)row recordNumber:(int)recordNumber
{
    NSMutableDictionary *rowData = [[NSMutableDictionary alloc] init];
    
    for (TOKCSVColumnDefinition *column in self.columnDefinitions)
    {
        NSInteger columnIndex = [self indexOfColumnDefinition:column];
        
        if (columnIndex != NSNotFound)
        {
            if (columnIndex < row.count)
            {
                NSString *rawData = [row objectAtIndex:columnIndex];
                if (column.isValidField(rawData))
                {
                    [rowData
                        setObject:[[TOKRowField alloc] initWithRawData:rawData transformedData:column.valueFromField(rawData)]
                        forKey:column.heading];
                }
                else
                {
                    //[NSException raise:NSGenericException format:@"'%@' is an invalid value for '%@' on line %li", rawData, column.heading, recordNumber];
                    
                    TOKImportMessage *message = [[TOKImportMessage alloc] initWithLineNumber:recordNumber message:[NSString stringWithFormat:@"'%@' is an invalid value for '%@' on line %i", rawData, column.heading, recordNumber] severity:TOKImportFatalError];
                    
                    [self.validationMessages addMessage:message];
                }
            }
            else
            {
                // The row doesn't contain data for the column
                if (column.mandatory)
                {
                    [self.validationMessages addMessage:[[TOKImportMessage alloc] initWithMessage:[NSString stringWithFormat:@"Mandatory column missing from file, %@", column.heading] severity:TOKImportFatalError]];
                    
                   //[NSException raise:NSGenericException format:@"Mandatory column missing from file, %@", column.heading];
                }
            }
        }
        else
        {
            
        }
    }

    return rowData.count > 0 ? rowData : nil;
}

#pragma mark - Export

-(void)exportData:(NSArray *)data file:(NSURL *)file
{
    self.fileURL = file;
    
    CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:[file relativePath]];
    
    // Write the headings
    for (TOKCSVColumnDefinition *column in self.columnDefinitions)
    {
        [writer writeField:column.heading];
    }
    [writer finishLine];
    
    // Write each row
    for (id dataItem in data)
    {
        // Output the field for each column
        for (TOKCSVColumnDefinition *column in self.columnDefinitions)
        {
            [writer writeField:column.fieldFromData(dataItem)];
        }
        [writer finishLine];
    }
}

#pragma mark - Validation

-(void)validate:(voidBlockWithImportResult)completionBlock
{
    if (self.fileURL)
    {
        [self validateFile:self.fileURL completionBlock:completionBlock];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Must define the file to import using init or importFile:completionBlock method."];
    }
}

-(void)validateFile:(NSURL *)file completionBlock:(voidBlockWithImportResult)completionBlock
{
    // This will add fatal errors to self.validationMessages if there are any missing columns
    [self checkForMandatoryColumns];
    
    // As long as nothing fatal happened, keep validating
    if ([self.validationMessages messagesOfSeverity:TOKImportCriticalFileError].count == 0)
    {
        [self processRowsAndSave:NO];
        
        // Add final summary messages
        [self.validationMessages addMessages:self.importSummaryMessages];
    }
    else
    {
        // Add some general information about the import
        NSString *information = @"The file can not be import as it contains some critcal errors.";
        [self.validationMessages addMessage:[[TOKImportMessage alloc] initWithMessage:information severity:TOKImportCriticalFileError]];
    }
    
    if (completionBlock)
    {
        TOKImportResult *result = [[TOKImportResult alloc] init];
        result.rawData = self.fileContentsRaw;
        result.savedData = nil;
        result.messages = self.validationMessages.messages.count > 0 ? self.validationMessages : nil;
        
        completionBlock(result);
    }
}

-(void)safeColumnFetchFromRowData:(NSDictionary *)rowData column:(TOKCSVColumnDefinition *)column
{
    
    @try
    {
        
    }
    @catch (NSException *exception)
    {
    }
}


-(BOOL)checkForMandatoryColumns
{
    BOOL result = YES;
    
    // Not possible to call this method without first defining columnDefinitions
    if (!self.columnDefinitions)
    {
        [NSException raise:NSInvalidArgumentException format:@"Must define columnDefinitions"];
    }
    else
    {
        // Check mandatory columns
        for (TOKCSVColumnDefinition *column in self.columnDefinitions)
        {
            if (column.mandatory && [self indexOfColumnDefinition:column] == NSNotFound)
            {
                // Missing mandatory column, creat critical error to prevent file being processed
                [self.validationMessages addMessage:[[TOKImportMessage alloc] initWithMessage:[NSString stringWithFormat:@"Missing column, %@", column.heading] severity:TOKImportCriticalFileError]];
                result = NO;
            }
        }
    }
    
    return result;
}


-(NSArray *)columnDefinitions
{
    [NSException raise:NSGenericException format:@"Must override columnDefinitions in subclass"];
    return nil;
}

-(id)processRowData:(NSDictionary *)data recordNumber:(NSUInteger)recordNumber save:(BOOL)save
{
    [NSException raise:NSGenericException format:@"Must override saveWithRowData:recordNumber in subclass"];
    return nil;
}

@end
