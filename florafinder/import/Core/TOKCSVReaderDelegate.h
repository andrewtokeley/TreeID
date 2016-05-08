//
//  TOKCSVParserDelegate.h
//  TrapLines
//
//  Created by Andrew Tokeley on 28/06/14.
//  Copyright (c) 2014 Andrew Tokeley. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TOKCSVReader;

@protocol TOKCSVReaderDelegate <NSObject>

-(void)reader:(TOKCSVReader *)reader saveRowData:(NSDictionary *)data recordNumber:(NSUInteger)recordNumber error:(NSError *)error;
-(void)readerDidEndDocument:(TOKCSVReader *)reader;

@end
