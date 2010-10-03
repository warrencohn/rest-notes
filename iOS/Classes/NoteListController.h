//
//  NoteListController.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/21.
//  Copyright 2010 IST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteConnector;

@class Note;

@interface NoteListController : UIViewController {
	UITableView *table;
	NSArray *notes;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *notes;

- (IBAction) reloadTable: (id) sender;
- (IBAction) logout: (id) sender;
- (void) notesLoaded: (NSArray*) theNotes;
- (void) noteDeleted: (Note*) note;

- (IBAction) newRandomNote: (id) sender;

@end
