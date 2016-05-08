//
//  TOKImportResult.h
//  TrapLines
//
//  Created by Andrew Tokeley on 14/07/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOKImportValidationMessages.h"

typedef NS_ENUM(NSInteger, TOKImportStatus)
{
    TOKImportStatusSuccess = 0,
    TOKImportStatusFail,
    TOKImportStatusPartialSuccess,
    TOKImportStatusUnknown
};

@interface TOKImportResult : NSObject

@property NSArray *rawData;
@property NSArray *savedData;
@property TOKImportValidationMessages *messages;
@property (readonly) NSUInteger validLinesCount;
@property (readonly) TOKImportStatus status;

@end
