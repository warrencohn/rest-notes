//
//  UserConnector.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/29.
//  Copyright 2010 IST. All rights reserved.
//

#import "UserConnector.h"
#import "User.h"
#import "RESTOperationWrapper.h"
#import "NSObject+SBJSON.h"
#import "NoteConnector.h"

@implementation UserConnector

+ (void) createUser: (User*) user delegate: (id) delegate callback: (SEL) theSelector errorCallback: (SEL) errorSelector {
	NSString *json = [[user dictionaryForSerialization] JSONRepresentation];
	NSDictionary *opts = [NSDictionary dictionaryWithObject:json forKey:@"body"];
	RESTOperationWrapper *wrapper = [RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector];
	[wrapper addErrorHandler:errorSelector forCode:500];
	[self postPath:@"/users.json" withOptions:opts object:wrapper];
}

+ (void) loginWithUsername: (NSString*) username password: (NSString*) password delegate: (id) delegate callback: (SEL) theSelector {
	[UserConnector setBasicAuthWithUsername:username password:password];
	[NoteConnector setBasicAuthWithUsername:username password:password];
	[self getPath:@"/user/login.json" withOptions:nil object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}

+ (void) logout {
	[UserConnector setBasicAuthWithUsername:nil password:nil];
	[NoteConnector setBasicAuthWithUsername:nil password:nil];
}

@end
