//
//  NoteController.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/21.
//  Copyright 2010 IST. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GenericConnector.h"

@class Note;

@interface NoteConnector : GenericConnector {
	
}

+ (void) fetchAllNotes: (id) delegate withCallback: (SEL) theSelector;
+ (void) fetchNoteWithId: (id) noteId delegate: (id) delegate callback: (SEL) theSelector;
+ (void) updateNote: (Note*) note delegate: (id) delegate callback: (SEL) theSelector;
+ (void) deleteNote: (Note*) note delegate: (id) delegate callback: (SEL) theSelector;
+ (void) createNote: (Note*) note delegate: (id) delegate callback: (SEL) theSelector;
+ (void) randomNoteWithDelegate: (id) delegate callback: (SEL) theSelector;

@end
