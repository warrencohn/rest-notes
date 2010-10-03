//
//  NoteController.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/21.
//  Copyright 2010 IST. All rights reserved.
//

#import "NoteConnector.h"
#import "Note.h"
#import "RESTOperationWrapper.h"
#import "NSObject+SBJSON.h"

@implementation NoteConnector

+ (void) fetchAllNotes: (id) delegate withCallback: (SEL) theSelector {
	[self getPath:@"/notes.json" withOptions:nil object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}

+ (void) fetchNoteWithId: (id) noteId delegate: (id) delegate callback: (SEL) theSelector {
	NSString *path = [NSString stringWithFormat:@"/note/%@.json", noteId];
	[self getPath:path withOptions:nil object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}

+ (void) updateNote: (Note*) note delegate: (id) delegate callback: (SEL) theSelector {
	NSString *json = [[note dictionaryForSerialization] JSONRepresentation];
	NSLog(@"%@", json);
	NSDictionary *opts = [NSDictionary dictionaryWithObject:json forKey:@"body"];
	NSString *path = [NSString stringWithFormat:@"/note/%@.json", [note noteId]];
	[self putPath:path withOptions:opts object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}

+ (void) deleteNote: (Note*) note delegate: (id) delegate callback: (SEL) theSelector {
	NSString *path = [NSString stringWithFormat:@"/note/%@.json", [note noteId]];
	[self deletePath:path withOptions:nil object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}

+ (void) createNote: (Note*) note delegate: (id) delegate callback: (SEL) theSelector {
	NSString *json = [[note dictionaryForSerialization] JSONRepresentation];
	NSLog(@"%@", json);
	NSDictionary *opts = [NSDictionary dictionaryWithObject:json forKey:@"body"];
	[self postPath:@"/notes.json" withOptions:opts object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}

+ (void) randomNoteWithDelegate: (id) delegate callback: (SEL) theSelector {
	[self getPath:@"/note/random.json" withOptions:nil object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}

@end
