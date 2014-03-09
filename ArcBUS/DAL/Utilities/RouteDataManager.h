//
//  RouteDataManager.h
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"
#import "SessionManagerDelegate.h"
#import "RouteDataManagerDelegate.h"
#import "../DataServices/NextbusDataService.h"
#import "../Models/SimpleRoute.h"

@interface RouteDataManager : NSObject <SessionManagerDelegate>

@property (strong) id<RouteDataManagerDelegate> delegate;
@property (strong) SessionManager *sessionManager;
@property (strong) NextbusDataService *nextbusDataService;
@property (strong) NSMutableArray *routeQueue;
@property (strong) NSMutableArray *priorityRouteQueue;
@property (nonatomic) BOOL isRetrievingDetails;

- (id)initWithDelegate:(id<RouteDataManagerDelegate>)delegate;
- (void)setRouteAsPriority:(SimpleRoute *)route;

@end
