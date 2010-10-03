//
//  User.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/29.
//  Copyright 2010 IST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString *username;
	NSString *password;
	NSString *userId;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userId;

- (id) initWithDictionary: (NSDictionary*) dict;
- (NSDictionary*) dictionaryForSerialization;
	
@end
