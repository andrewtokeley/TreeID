//
//  TOKRowField.m
//  TrapLines
//
//  Created by Andrew Tokeley on 6/09/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import "TOKRowField.h"

@implementation TOKRowField

-(id)initWithRawData:(NSString *)rawData transformedData:(id)transformedData
{
    self = [super init];
    if (self)
    {
        self.rawData = rawData;
        self.transformedData = transformedData;
    }
    return self;
}
@end
