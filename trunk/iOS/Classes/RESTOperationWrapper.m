//
//  RESTOperationWrapper.m
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/24.
//  Copyright 2010 IST. All rights reserved.
//

#import "RESTOperationWrapper.h"


@implementation RESTOperationWrapper

@synthesize object;
@synthesize selector;
@synthesize errorSelectors;

+ (RESTOperationWrapper*) wrapperForDelegate: (id) theObject andSelector: (SEL) theSelector {
	RESTOperationWrapper *wrapper = [[RESTOperationWrapper alloc] init];
	[wrapper setErrorSelectors:[NSMutableDictionary dictionary]];
	[wrapper setObject:theObject];
	[wrapper setSelector:theSelector];
	return wrapper;
}

- (void) addErrorHandler: (SEL) errorSelector forCode: (int) errorCode {
	[[self errorSelectors] setObject:NSStringFromSelector( errorSelector ) forKey:[NSNumber numberWithInt:errorCode]];
}

- (SEL) errorHandlerForCode: (int) errorCode {
	return NSSelectorFromString( [[self errorSelectors] objectForKey:[NSNumber numberWithInt:errorCode]] );
}

- (void) dealloc
{
	[self setObject:nil];
	[self setErrorSelectors:nil];
	[super dealloc];
}


@end
