//
//  TOKRowField.h
//  TrapLines
//
//  Created by Andrew Tokeley on 6/09/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOKRowField : NSObject

-(id)initWithRawData:(NSString *)rawData transformedData:(id)transformedData;

/**
 @brief The raw data contained in the file for this field
 */
@property NSString *rawData;

/**
 @brief The transformed raw data. This is determined from the columnDefinition for this field and the valueFromField block.
 */
@property id transformedData;

@end
