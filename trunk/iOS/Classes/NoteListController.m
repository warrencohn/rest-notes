//
//  NoteListController.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/21.
//  Copyright 2010 IST. All rights reserved.
//

#import "NoteListController.h"
#import "RESTNotesAppDelegate.h"
#import "Note.h"
#import "NoteConnector.h"
#import "NoteEditController.h"
#import "constants.h"
#import "UserConnector.h"

@implementation NoteListController

@synthesize table;
@synthesize notes;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( notesUpdatedNotificationTriggered: ) name:NOTES_UPDATED_NOTIFICATION object:nil];
    }
    return self;
}

- (void) notesUpdatedNotificationTriggered: (NSNotification*) notification {
	[self reloadTable:self];
}

- (void)viewDidLoad {
	[self setNotes:nil];
	[NoteConnector fetchAllNotes:self withCallback:@selector( notesLoaded: )];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector( reloadTable: )];
	[[self navigationItem] setLeftBarButtonItem:item];
	[item release];
	
	item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector( newNote: )];
	[[self navigationItem] setRightBarButtonItem:item];
	[item release];
}

- (void) notesLoaded: (NSArray*) theNotes {
	[self setNotes:theNotes];
	[[self table] reloadData];
}

- (void) newNote: (id) sender {
	UINavigationController* navigationController = [((RESTNotesAppDelegate *)[[UIApplication sharedApplication] delegate]) navigationController];
	
	NoteEditController *noteEditController = [[NoteEditController alloc] initWithNibName:@"NoteEditController" bundle:nil noteId:nil];
	[navigationController pushViewController:noteEditController animated:YES];
	[noteEditController release];
}

- (IBAction) newRandomNote: (id) sender {
	UINavigationController* navigationController = [((RESTNotesAppDelegate *)[[UIApplication sharedApplication] delegate]) navigationController];
	
	NoteEditController *noteEditController = [[NoteEditController alloc] initWithRandomNoteNibName:@"NoteEditController" bundle:nil];
	[navigationController pushViewController:noteEditController animated:YES];
	[noteEditController release];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[[self table] reloadData];
	[super viewWillAppear:animated];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self notes] count];
}

- (void) noteDeleted: (Note*) note {
	// Do nothing
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTable cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [theTable dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    
    cell.textLabel.text = [[[self notes] objectAtIndex:[indexPath row]] content];
	
    return cell;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		Note *note = [[self notes] objectAtIndex:[indexPath row]];
		[NoteConnector deleteNote:note delegate:self callback:@selector(noteDeleted:)];
		
		NSMutableArray *notesTemp = [NSMutableArray arrayWithArray:[self notes]];
		[notesTemp removeObjectAtIndex:[indexPath row]];
		[self setNotes:[NSArray arrayWithArray:notesTemp]];
		
		[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UINavigationController* navigationController = [((RESTNotesAppDelegate *)[[UIApplication sharedApplication] delegate]) navigationController];
	
	NoteEditController *noteEditController = [[NoteEditController alloc] initWithNibName:@"NoteEditController" bundle:nil noteId:[[[self notes] objectAtIndex:[indexPath row]] noteId]];
	[navigationController pushViewController:noteEditController animated:YES];
	[noteEditController release];
}

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction) logout: (id) sender {
	[UserConnector logout];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self setNotes:nil];
    [super dealloc];
}

- (IBAction) reloadTable: (id) sender {
	[NoteConnector fetchAllNotes:self withCallback:@selector( notesLoaded: )];
}




@end
