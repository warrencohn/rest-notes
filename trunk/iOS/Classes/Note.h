//
//  Note.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/21.
//  Copyright 2010 IST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject {
	NSString *content;
	NSString *noteId;
}

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *noteId;

- (id) initWithDictionary: (NSDictionary*) dict;
- (NSDictionary*) dictionaryForSerialization;

@end
