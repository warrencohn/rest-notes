//
//  User.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/29.
//  Copyright 2010 IST. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize username;
@synthesize password;
@synthesize userId;

- (id) initWithDictionary: (NSDictionary*) dict
{
	self = [super init];
	if (self != nil) {
		[self setUsername:[dict objectForKey:@"username"]];
	}
	return self;
}

- (NSDictionary*) dictionaryForSerialization {
	NSString *tempUserId = ([self userId] == nil) ? @"-1" : [self userId];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:tempUserId, [self username], [self password], @"User", nil]
														   forKeys:[NSArray arrayWithObjects:@"id", @"username", @"password", @"type", nil]];
	return dictionary;
}

@end
