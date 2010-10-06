//
//  GenericConnector.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/24.
//  Copyright 2010 IST. All rights reserved.
//

#import "GenericConnector.h"
#import "RESTOperationWrapper.h"

@implementation GenericConnector

+ (void)initialize {
    [self setDelegate:self];
    [self setBaseURL:[NSURL URLWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"NotesURL"]]];
}

#pragma mark - HRRequestOperation Delegates
+ (void)restConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error object:(id)object {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect to the server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

// Handle invalid responses, 404, 500, etc.
+ (void)restConnection:(NSURLConnection *)connection didReceiveError:(NSError *)error response:(NSHTTPURLResponse *)response object:(id)del {
	NSInteger code = [error code];
	SEL errorSelector = [del errorHandlerForCode:code];
	
	if( errorSelector != nil ) {
		[[del object] performSelector:errorSelector withObject:[[response allHeaderFields] objectForKey:@"X-Restnotes-Error"]]; 
	} else if( code == 403 ) { 
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication error" message:@"Wrong user or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The server returned an error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

+ (void)restConnection:(NSURLConnection *)connection didReceiveParseError:(NSError *)error responseBody:(NSString *)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Parse error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource  object:(id)del {
	if( resource == nil ) {
		[[del object] performSelector:[del selector] withObject:nil];
	} else if( [resource isKindOfClass: [NSArray class]] ) {
		NSMutableArray *objects = [[[NSMutableArray alloc] init] autorelease];
		
		for(id item in resource) {
			[objects addObject:[self createObjectWithDictionary: item]];
		}
		
		[[del object] performSelector:[del selector] withObject:objects];
	} else {
		[[del object] performSelector:[del selector] withObject:[self createObjectWithDictionary: resource]];
	}
}

+ (id) createObjectWithDictionary: (NSDictionary*) dict {
	Class theClass = NSClassFromString([dict objectForKey:@"type"]);
	
	if( theClass != nil && [theClass instancesRespondToSelector:@selector( initWithDictionary: )] ) {
		return [[theClass alloc] performSelector:@selector( initWithDictionary: ) withObject:dict];
	} else {
		return dict;
	}
}

@end
