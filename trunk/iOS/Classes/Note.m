//
//  Note.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/21.
//  Copyright 2010 IST. All rights reserved.
//

#import "Note.h"


@implementation Note

@synthesize content;
@synthesize noteId;

- (id) initWithDictionary: (NSDictionary*) dict
{
	self = [super init];
	if (self != nil) {
		[self setNoteId:[dict objectForKey:@"id"]];
		if( [dict objectForKey:@"content"] != nil ) {
			[self setContent:[dict objectForKey:@"content"]];
		} else {
			[self setContent:[dict objectForKey:@"contentPreview"]];
		}		
	}
	return self;
}

- (NSDictionary*) dictionaryForSerialization {
	NSString *tempNoteId = ([self noteId] == nil) ? @"-1" : [self noteId];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tempNoteId, [self content], @"Note", nil]
														   forKeys:[NSArray arrayWithObjects:@"id", @"content", @"type", nil]];
	return dictionary;
}

@end
