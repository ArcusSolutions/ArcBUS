//
//  RouteDataManager.m
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "RouteDataManager.h"

static RouteDataManager *routeDataManager;

@implementation RouteDataManager

- (id)init
{
    if (routeDataManager == nil) {
        routeDataManager = [super init];
        routeDataManager.sessionManager = [[SessionManager alloc] initWithDelegate:self];
        routeDataManager.nextbusDataService = [[NextbusDataService alloc] init];
        routeDataManager.routeQueue = [[NSMutableArray alloc] init];
        routeDataManager.priorityRouteQueue = [[NSMutableArray alloc] init];
    }
    
    self = routeDataManager;
    return self;
}


- (id)initWithDelegate:(id<RouteDataManagerDelegate>)delegate
{
    self = [self init];
    self.delegate = delegate;
    return self;
}


- (void)setRouteAsPriority:(SimpleRoute *)route
{
    if ([self.routeQueue containsObject:route]) {
        [self.routeQueue removeObject:route];
        [self.priorityRouteQueue addObject:route];
    }
}


- (void)routeListUpdated:(NSArray *)routeList
{
    int index = 0;
    while ([routeList count] > index) {
        SimpleRoute *route = [routeList objectAtIndex:index];
        if (![self.routeQueue containsObject:route]) {
            [self.routeQueue addObject:route];
        }
        index++;
    }
    
    if (!self.isRetrievingDetails && [self.routeQueue count] > 0) {
        [self performSelectorInBackground:@selector(retrieveRouteDetailsFromQueue) withObject:nil];
    }
}


- (void)retrieveRouteDetailsFromQueue
{
    self.isRetrievingDetails = YES;
    
    while ([self.priorityRouteQueue count] > 0 || [self.routeQueue count] > 0) {
        SimpleRoute *activeRoute;
        if ([self.priorityRouteQueue count] > 0) {
            activeRoute = [self.priorityRouteQueue objectAtIndex:0];
            [self.priorityRouteQueue removeObjectAtIndex:0];
        } else {
            activeRoute = [self.routeQueue objectAtIndex:0];
            [self.routeQueue removeObjectAtIndex:0];
        }
        
        DetailedRoute *routeDetails = [self.nextbusDataService getRouteDetails:activeRoute];
        [self.sessionManager addDetailsForRoute:routeDetails];
    }
    
    self.isRetrievingDetails = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate != nil) {
            [self.delegate routeDataFinishedLoading];
        }
    });
}


- (void)routeDetailsReceived:(DetailedRoute *)routeDetails {}
- (void)recentRoutesUpdated:(NSArray *)recentRoutes {}

@end
