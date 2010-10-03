//
//  UserConnector.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/29.
//  Copyright 2010 IST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericConnector.h"

@class User;

@interface UserConnector : GenericConnector {
	
}

+ (void) createUser: (User*) user delegate: (id) delegate callback: (SEL) theSelector errorCallback: (SEL) errorSelector;
+ (void) loginWithUsername: (NSString*) username password: (NSString*) password delegate: (id) delegate callback: (SEL) theSelector;
+ (void) logout;

@end
