//
//  TOKCSVColumnDefinition.m
//  TrapLines
//
//  Created by Andrew Tokeley on 22/06/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import "TOKCSVColumnDefinition.h"

@implementation TOKCSVColumnDefinition
@synthesize valueFromField = _valueFromField;
@synthesize isValidField = _isValidField;

-(id)initWithHeading:(NSString *)heading mandatory:(BOOL)mandatory
{
    self = [super init];
    if (self)
    {
        self.heading = heading;
        self.mandatory = mandatory;
    }
    return self;
}

-(void)setValueFromField:(untypedBlockWithString)valueFromField
{
    _valueFromField = valueFromField;
}

-(untypedBlockWithString)valueFromField
{
    if (!_valueFromField)
    {
        _valueFromField = (id)^(NSString *field)
        {
            id returnValue = nil;
            if (field.length > 0)
                returnValue = field;
            
            return returnValue;
        };
    }
    return _valueFromField;
}

-(void)setIsValidField:(booleanBlockWithString)isValidField
{
    _isValidField = isValidField;
}

-(booleanBlockWithString)isValidField
{
    if (!_isValidField)
    {
        // Default implementation is to assume field is valid
        _isValidField = (id)^(NSString *field)
        {
            return YES;
        };
    }
    return _isValidField;
}


@end
