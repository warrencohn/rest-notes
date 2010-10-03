//
//  NoteEditController.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/25.
//  Copyright 2010 IST. All rights reserved.
//

#import "NoteEditController.h"
#import "Note.h"
#import "NoteConnector.h"
#import "NoteListController.h"
#import "constants.h"

@implementation NoteEditController

@synthesize noteView;
@synthesize note;
@synthesize noteId;
@synthesize isRandom;

/* - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
} */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil noteId: (id) theNoteId {
    if ((self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self setNoteId: theNoteId];
		[self setIsRandom:NO];
    }
    return self;
}

- (id)initWithRandomNoteNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil noteId:nil])) {
        [self setIsRandom:YES];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	if( [self noteId] != nil ) {
		[NoteConnector fetchNoteWithId:[self noteId] delegate:self callback:@selector(gotNote:)];
		[[self noteView] setText:@""];
		[[self noteView] setEditable:NO];
	} else if( [self isRandom] ) {
		[NoteConnector randomNoteWithDelegate:self callback:@selector(gotRandomNote:)];
		[[self noteView] setText:@""];
		[[self noteView] setEditable:NO];
	} else {
		Note *tempNote = [[Note alloc] init];
		[tempNote setContent:@"New Note"];
		[NoteConnector createNote:tempNote delegate:self callback:@selector(createdNote:)];
		[tempNote release];
		[[self navigationItem] setHidesBackButton:YES animated:NO];
	}
}

- (void) createdNote: (Note*) theNote {
	[self setNote:theNote];
	[[self noteView] setText:[[self note] content]];
	[[self noteView] setEditable:YES];
	[[self noteView] selectAll:self];
}

- (void) gotNote: (Note*) theNote {
	[self setNote:theNote];
	[[self noteView] setText:[[self note] content]];
	[[self noteView] setEditable:YES];
}

- (void) gotRandomNote: (Note*) theNote {
	[self setNoteId:[theNote noteId]];
	[self gotNote:theNote];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTES_UPDATED_NOTIFICATION object:nil];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	[[self navigationItem] setHidesBackButton:YES animated:YES];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector( doneEditing: )];
	[[self navigationItem] setRightBarButtonItem:item];
	[item release];
	
	//[[self navigationController] setNavigationBarHidden:YES animated:YES];
	return YES;
}

- (void) doneEditing: (id) sender {
	[[self noteView] resignFirstResponder];
	[[self navigationItem] setRightBarButtonItem:nil];
	[[self navigationItem] setTitle:@"Saving…"];
	
	[[self note] setContent:[noteView text]];
	[NoteConnector updateNote:[self note] delegate:self callback:@selector( didSaveNote: )];
}

- (void) didSaveNote: (Note*) theNote {
	[[self navigationItem] setTitle:@""];
	[[self navigationItem] setHidesBackButton:NO animated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTES_UPDATED_NOTIFICATION object:nil];
}
	 
- (void)textViewDidEndEditing:(UITextView *)textView {
	//[[self navigationController] setNavigationBarHidden:NO animated:YES];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
