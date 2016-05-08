//
//  TOKCSVReader.m
//  TrapLines
//
//  Created by Andrew Tokeley on 22/06/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import "TOKCSVReader.h"
#import "TOKCSVColumnDefinition.h"

#define COMMA ','
NSString * const TOKCSVReaderDomain = @"TOKCSVReaderDomain";
NSString * const TOKMissingColumnsErrorKey = @"TOKMissingColumnsErrorKey";
NSString * const TOKCSVValidationErrorKey = @"TOKCSVValidationErrorKey";

@interface TOKCSVReader ()

@property (readonly) CHCSVParser *parser;
@property (readonly) NSArray *header;

@property NSMutableArray *rowValidationsErrors;
@property NSMutableDictionary *rowResult;

@property NSUInteger currentLine;

@end

@implementation TOKCSVReader
@synthesize header = _header;
@synthesize fileContents = _fileContents;

-(id)initWithFileURL:(NSURL *)fileURL
{
    return [self initWithFilePath:[fileURL relativePath]];
}

-(id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self)
    {
        _filePath = filePath;
        _parser = [[CHCSVParser alloc] initWithContentsOfCSVFile:filePath delimiter:COMMA];
        _parser.stripsLeadingAndTrailingWhitespace = YES;
        _parser.recognizesBackslashesAsEscapes = YES;
        _parser.sanitizesFields = YES;
        _parser.delegate = self;
    }
    return self;
}

/* Returns the TOKCSVColumnDefinition at the specified column index. If not columnDefinition has been defined, a nil is returned.
 */
-(TOKCSVColumnDefinition *)columnDefinitionAtIndex:(NSInteger)index
{
    TOKCSVColumnDefinition *column = nil;
    
    if (self.header)
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
    
    if (self.header)
    {
        NSUInteger index = [self.header indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
            NSString *heading = (NSString *)obj;
            return [heading isEqualToString:columnDefinition.heading];
        }];
        
        if (index != NSNotFound)
        {
            result = index;
        }
    }
    return result;
}

-(NSArray *)fileContents
{
    if (!_fileContents)
    {
        _fileContents = [NSArray arrayWithContentsOfCSVFile:self.filePath options:CHCSVParserOptionsStripsLeadingAndTrailingWhitespace];
    }
    return _fileContents;
}

-(NSArray *)header
{
    if (!_header)
    {
        _header = [self.fileContents objectAtIndex:0];
    }
    return _header;
}

-(BOOL)validateColumns:(NSError **)error
{
    NSMutableArray *errorMessages = [[NSMutableArray alloc] init];

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
                // Missing mandatory column
                [errorMessages addObject:[NSString stringWithFormat:@"%@", column.heading]];
            }
        }
    }

    if (errorMessages.count > 0)
    {
        if (error)
        {
            *error = [NSError errorWithDomain:TOKCSVReaderDomain code:0 userInfo:@{TOKMissingColumnsErrorKey: errorMessages}];
        }
        return NO;
    }

    return YES;
}


-(void)parse
{
    // Kick of the parse process
    [self.parser parse];
}

#pragma mark - Parser

-(void)parserDidBeginDocument:(CHCSVParser *)parser
{
    NSLog(@"start");
}

-(void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    // Initialise new row
    self.currentLine = recordNumber;
    self.rowResult = [[NSMutableDictionary alloc] init];
    self.rowValidationsErrors = [[NSMutableArray alloc] init];
}

-(void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    // Get the columndefinition
    TOKCSVColumnDefinition *column = [self columnDefinitionAtIndex:fieldIndex];
    
    if (column && self.currentLine > 1)
    {
        id value = nil;
        @try
        {
            value = column.valueFromField(field);
        }
        @catch (NSException *exception)
        {
            value = @"";
            [self.rowValidationsErrors addObject:[[NSString stringWithFormat:@"Line %lu:",(unsigned long)self.currentLine] stringByAppendingString:exception.reason]];
        }
        @finally
        {
            if (value)
                [self.rowResult setObject:value forKey:self.header[fieldIndex]];
        }
    }
}

-(void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    NSError *error = nil;
    
    if (self.rowValidationsErrors.count > 0)
    {
        error = [NSError errorWithDomain:TOKCSVReaderDomain code:0 userInfo:@{TOKCSVValidationErrorKey: self.rowValidationsErrors}];
    }
    
    [self.delegate reader:self saveRowData:self.rowResult recordNumber:recordNumber error:error];
}

-(void)parserDidEndDocument:(CHCSVParser *)parser
{
    [self.delegate readerDidEndDocument:self];
}

-(void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    // Give delegate the option of saving a partial read, if an error occurs.
    [self.delegate reader:self saveRowData:self.rowResult recordNumber:self.currentLine error:error];
}

@end
