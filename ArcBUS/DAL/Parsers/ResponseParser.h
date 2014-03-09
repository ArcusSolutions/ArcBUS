//
//  ResponseParser.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/15/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities/XMLUtil.h"
#import "../Models/Response.h"

@interface ResponseParser : NSObject

- (Response *)parseResponseFromJSON:(NSString *)json;

@end
