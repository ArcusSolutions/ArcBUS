//
//  RouteParser.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/Response.h"
#import "../Models/SimpleRoute.h"
#import "../Models/DetailedRoute.h"
#import "../Models/RouteDirection.h"
#import "../Models/RouteStop.h"
#import "../Models/PredictionsWrapper.h"
#import "../Models/PredictionsDirection.h"
#import "../Models/Prediction.h"

@interface RouteParser : NSObject

- (NSArray *)parseRouteListFromResponse:(Response *)response;
- (DetailedRoute *)parseRouteConfigFromResponse:(Response *)response;
- (NSArray *)parsePredictionsFromResponse:(Response *)response;

@end
