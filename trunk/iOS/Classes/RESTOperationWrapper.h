//
//  RESTOperationWrapper.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/24.
//  Copyright 2010 IST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RESTOperationWrapper : NSObject {
	id object;
	SEL selector;
	NSMutableDictionary *errorSelectors;
}

@property (nonatomic, retain) id object;
@property (nonatomic) SEL selector;
@property (nonatomic, retain) NSMutableDictionary *errorSelectors;

+ (RESTOperationWrapper*) wrapperForDelegate: (id) theObject andSelector: (SEL) theSelector;
- (void) addErrorHandler: (SEL) errorSelector forCode: (int) errorCode;
- (SEL) errorHandlerForCode: (int) errorCode;	

@end
