//
//  TOKCSVParser.h
//  TrapLines
//
//  Created by Andrew Tokeley on 30/06/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TOKConstants.h"
#import "TOKCSVReaderDelegate.h"
#import "TOKCSVColumnDefinition.h"
#import "TOKImportResult.h"
#import "CHCSVParser.h"

extern NSString * const TOKValidationErrorKey;
typedef void (^voidBlockWithImportResult)(TOKImportResult *);
typedef void (^voidBlockWithValidationMessages)(TOKImportValidationMessages *);

@interface TOKCSVParser : NSObject <CHCSVParserDelegate>

-(id)init;
-(id)initWithFileURL:(NSURL *)fileURL;

/* Subclasses can add valudation errors to this array and they will be returned in the parse and validate completionBlocks
 */
//@property (readonly) NSMutableArray *validationErrors;
@property (readonly) TOKImportValidationMessages *validationMessages;

/* Final results are added to this array and will be returned in the parse completionBlock
 */
@property (readonly) NSMutableArray *results;

/* Initiate the file import. Subclasses must handle the reader:saveRowData:recordNumber:error method to persist data and report import errors, if required.
 */
-(void)importFile:(voidBlockWithImportResult)completionBlock;
-(void)importFile:(NSURL *)file completionBlock:(voidBlockWithImportResult)completionBlock;

/**
 @brief This method must be overriden by subclasses. This method is called for each row of the file and is used to, validate and optionally save, a single transformed row. Dictionary keys are the columns headings and object values are the raw file data, transformed by the column definitions (typically to format and strongly type). The method can be told to save the data (to a data store) or not - typically this is to allow the method to run as a pre-save validation of the file contents.
 
 @param data NSDictionary of the row data. The Key reppresents the name of the column and the Value is the strongly typed value.
 @param recordNumber the record number. The header row is not counted, so 1 is in fact the 2nd row but 1st row of data to process.
 @param save flag to save the results of processing the row
 
 @return a strongly typed object that represents the row data.
 */
-(id)processRowData:(NSDictionary *)data recordNumber:(NSUInteger)recordNumber save:(BOOL)save;

/**
 @brief Validates the file (supplied during initialisation) and returns an array of validation errors, if any. Subclasses must override this method to provide custom validation. No records should be created as a result of calling this method.
 
 @param completionBlock block that will be called once the file has been validated.
 */
-(void)validate:(voidBlockWithImportResult)completionBlock;

/**
 @brief Validates the file and returns an array of validation errors, if any. Subclasses must override this method to provide custom validation. No records should be created as a result of calling this method.
 
 @param completionBlock block that will be called once the file has been validated.
 */
-(void)validateFile:(NSURL *)file completionBlock:(voidBlockWithImportResult)completionBlock;


//-(void)safeColumnFetchFromRowData:(NSDictionary *)rowData column:(TOKCSVColumnDefinition *)column;

/**
 @brief Exports the data to a file
 
 @param data the data to export. This data should match the column definitions so that the correct values can be extracted from the array of objects supplied
 */
-(void)exportData:(NSArray *)data file:(NSURL *)file;

/* Returns the columnDefinitions for a given file import - this property must be overriden in subclasses
 */
@property (readonly) NSArray *columnDefinitions;

/* Returns whether all mandatory columns are present. This method adds fatal errors to self.validationMessages if missing columns found.
 */
-(BOOL)checkForMandatoryColumns;

/* Returns a summary of what has/will be imported - if not overriden by subclasses will simply return how many records will be imported.
 */
@property (readonly) NSArray *importSummaryMessages;

@end
