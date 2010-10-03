//
//  GenericConnector.h
//  RESTNotes
//
//  Created by Miguel Arroz on 10/09/24.
//  Copyright 2010 IST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRRestModel.h"

@interface GenericConnector : HRRestModel {

}

+ (id) createObjectWithDictionary: (NSDictionary*) dict;

@end
