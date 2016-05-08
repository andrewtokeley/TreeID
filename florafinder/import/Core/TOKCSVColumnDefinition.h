//
//  TOKCSVColumnDefinition.h
//  TrapLines
//
//  Created by Andrew Tokeley on 22/06/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TOKConstants.h"

@interface TOKCSVColumnDefinition : NSObject

typedef NSString* (^stringBlockWithId)(id);
typedef id (^untypedBlockWithString)(NSString *);
typedef BOOL (^booleanBlockWithString)(NSString *);

-(id)initWithHeading:(NSString *)heading mandatory:(BOOL)mandatory;

// Heading that identifies the position of this column definition
@property NSString *heading;

// Returns whether the column is mandatory
@property BOOL mandatory;

// Predicate returning whether the given field is valid
@property NSPredicate *fieldValidator;

// Block to accept a string and return the typed value for the field
@property (copy)untypedBlockWithString valueFromField;

// Block to accept a data structure and returns a formatted string for the export field. For example, Data could be a person and this method could return person.FirstName.
@property (copy)stringBlockWithId fieldFromData;

// Block to return whether the raw field data is valid. Typically does type checking or whether a value is a valid lookup entry
@property (copy)booleanBlockWithString isValidField;

@end
