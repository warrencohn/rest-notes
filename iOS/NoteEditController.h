//
//  NoteEditController.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/25.
//  Copyright 2010 IST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

@interface NoteEditController : UIViewController {
	UITextView *noteView;
	Note *note;
	id noteId;
	BOOL isRandom;
}

@property( nonatomic, retain ) IBOutlet UITextView *noteView;
@property( nonatomic, retain ) Note *note;
@property( nonatomic, retain ) id noteId;
@property( nonatomic ) BOOL isRandom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil noteId: (id) noteId;
- (id)initWithRandomNoteNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void) createdNote: (Note*) theNote;
- (void) gotNote: (Note*) theNote;
- (void) gotRandomNote: (Note*) theNote;

@end
