//
//  LoginController.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/29.
//  Copyright 2010 IST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface LoginController : UIViewController {
	UITextField *username;
	UITextField *password;
}

@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;

- (IBAction) login: (id) sender;
- (IBAction) registerNewUser: (id) sender;
- (void) loginSuccessful: (User*) user;

@end
