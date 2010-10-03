//
//  LoginController.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/29.
//  Copyright 2010 IST. All rights reserved.
//

#import "LoginController.h"
#import "NSStringAdditions.h"
#import "User.h"
#import "UserConnector.h"
#import "NoteListController.h"

@implementation LoginController

@synthesize username;
@synthesize password;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if( textField == [self username] ) {
		[[self password] selectAll:self];
		return NO;
	} else if( textField == [self password] ) {
		[[self password] resignFirstResponder];
		[self login:self];
		return NO;
	}
	
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void) stopEditingFields {
	if( [[self username] isFirstResponder] ) {
		[[self username] resignFirstResponder];
	} else if( [[self password] isFirstResponder] ) {
		[[self password] resignFirstResponder];
	}
}

- (IBAction) login: (id) sender {
	[self stopEditingFields];
	
	[UserConnector loginWithUsername:[[self username] text] password:[[self password] text] delegate:self callback:@selector( loginSuccessful: )];
}

- (void) loginSuccessful: (User*) user {
	NoteListController *noteListController = [[NoteListController alloc] initWithNibName:@"NoteListController" bundle:nil];
	[[self navigationController] pushViewController:noteListController animated:YES];
	[noteListController release];
}

- (IBAction) registerNewUser: (id) sender {
	[self stopEditingFields];
	
	NSString *user = [[[self username] text] stringByTrimming];
	NSString *pass = [[self password] text];
	
	if( user == nil || pass == nil || [user isEqualToString:@""] || [pass isEqualToString:@""] ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid user or password" message:@"User and password cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	User *newUser = [[User alloc] init];
	[newUser setUsername:user];
	[newUser setPassword:pass];
	[UserConnector createUser:newUser delegate:self callback:@selector( userCreated: ) errorCallback:@selector( errorCreatingUser: )];
	[newUser release];
}

- (void) userCreated: (User*) user {
	[self login:self];
}

- (void) errorCreatingUser: (NSString*) error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[[self username] selectAll:self];
}

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
