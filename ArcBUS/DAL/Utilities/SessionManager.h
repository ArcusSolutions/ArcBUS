//
//  SessionManager.h
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManagerDelegate.h"
#import "../Models/SimpleRoute.h"
#import "../Models/DetailedRoute.h"
#import "../Models/RouteDirection.h"

@interface SessionManager : NSObject

@property (nonatomic, strong) NSMutableArray *delegates;
@property (nonatomic, strong) NSArray *routeList;
@property (nonatomic, strong) NSMutableDictionary *routeDetails;
@property (nonatomic, strong) NSMutableArray *recentRoutes;
@property (nonatomic, strong) NSMutableArray *savedRoutes;

- (id)initWithDelegate:(id<SessionManagerDelegate>)delegate;
- (void)setSimpleRouteList:(NSArray *)routeList;
- (void)addDetailsForRoute:(DetailedRoute *)routeDetails;
- (void)addRouteToHistory:(DetailedRoute *)route WithDirection:(RouteDirection *)direction;
- (BOOL)isRouteSaved:(DetailedRoute *)route WithDirection:(RouteDirection *)direction;
- (void)toggleSavedStatusOfRoute:(DetailedRoute *)route WithDirection:(RouteDirection *)direction;

@end
