//
//  TOKExportResult.h
//  TrapLines
//
//  Created by Andrew Tokeley on 20/09/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOKExportResult : NSObject

/**
 The NSURL where the export file was created
 */
@property NSURL *fileURL;

/**
 Status of the export, YES if export was successful.
 */
@property BOOL status;

/**
 Summary of export, whether failed or succeeded
 */
@property NSString *summary;

@end
