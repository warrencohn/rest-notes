//
//  RESTNotesAppDelegate.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/21.
//  Copyright 2010 IST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteConnector;
@class NoteListController;

@interface RESTNotesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NoteConnector *noteController;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NoteConnector *noteController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

