//
//  SessionManager.m
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "SessionManager.h"


@implementation SessionManager

static SessionManager *sessionManager;

- (id)init
{
    if (sessionManager == nil) {
        sessionManager = [super init];
        sessionManager.delegates = [[NSMutableArray alloc] init];
        sessionManager.routeList = [[NSArray alloc] init];
        sessionManager.routeDetails = [[NSMutableDictionary alloc] init];
        
        sessionManager.recentRoutes = [self loadRoutesWithKey:@"RecentRoutes"];
        sessionManager.savedRoutes = [self loadRoutesWithKey:@"Favorites"];
    }
    
    self = sessionManager;
    return self;
}


- (id)initWithDelegate:(id<SessionManagerDelegate>)delegate
{
    self = [self init];
    [self.delegates addObject:delegate];
    return self;
}


- (void)addDetailsForRoute:(DetailedRoute *)routeDetails
{
    if (routeDetails != nil) {
        [sessionManager.routeDetails setObject:routeDetails forKey:routeDetails.tag];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id<SessionManagerDelegate> delegate in self.delegates) {
                [delegate routeDetailsReceived:routeDetails];
            }
        });
    }
}


- (void)setSimpleRouteList:(NSArray *)routeList
{
    self.routeList = routeList;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<SessionManagerDelegate> delegate in self.delegates) {
            [delegate routeListUpdated:routeList];
        }
    });
}


- (void)addRouteToHistory:(DetailedRoute *)route WithDirection:(RouteDirection *)direction
{
    for (NSDictionary *recentRouteData in sessionManager.recentRoutes) {
        RouteDirection *directionData = [recentRouteData objectForKey:@"direction"];
        DetailedRoute *routeData = [recentRouteData objectForKey:@"route"];
        
        if ([routeData.tag isEqualToString:route.tag] && [directionData.tag isEqualToString:direction.tag]) {
            [sessionManager.recentRoutes removeObject:recentRouteData];
            break;
        }
    }
    
    NSMutableDictionary *historyItem = [[NSMutableDictionary alloc] init];
    [historyItem setObject:route forKey:@"route"];
    [historyItem setObject:direction forKey:@"direction"];
    NSDictionary *historyItemDict = [NSDictionary dictionaryWithDictionary:historyItem];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:historyItemDict, nil];
    [temp addObjectsFromArray:sessionManager.recentRoutes];
    sessionManager.recentRoutes = temp;
    
    if ([sessionManager.recentRoutes count] > 5) [sessionManager.recentRoutes removeLastObject];
    
    [self saveRoutes:self.recentRoutes withKey:@"RecentRoutes"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<SessionManagerDelegate> delegate in self.delegates) {
            [delegate recentRoutesUpdated:sessionManager.recentRoutes];
        }
    });
}

-(void) saveRoutes:(NSMutableArray *)routes withKey:(NSString*)key
{
    NSMutableArray *routeDataArray = [[NSMutableArray alloc] init];
    for(NSDictionary *routeDataDictionary in routes)
    {
        NSData *route = [NSKeyedArchiver archivedDataWithRootObject:[routeDataDictionary objectForKey:@"route"]];
        NSData *direction = [NSKeyedArchiver archivedDataWithRootObject:[routeDataDictionary objectForKey:@"direction"]];
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        [tempDictionary setObject:route forKey:@"route"];
        [tempDictionary setObject:direction forKey:@"direction"];
        [routeDataArray addObject:tempDictionary];
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:routeDataArray forKey:key];
    [defaults synchronize];
}

-(NSMutableArray*) loadRoutesWithKey:(NSString*)key
{
    NSMutableArray *routes = [[NSMutableArray alloc] init];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray *routeDataArray = [defaults objectForKey:key];
    if(routeDataArray == nil)
        return routes;
    for(NSDictionary *routeDataDictionary in routeDataArray)
    {
        DetailedRoute *route = [NSKeyedUnarchiver unarchiveObjectWithData:[routeDataDictionary objectForKey:@"route"]];
        RouteDirection *direction = [NSKeyedUnarchiver unarchiveObjectWithData:[routeDataDictionary objectForKey:@"direction"]];
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        [tempDictionary setObject:route forKey:@"route"];
        [tempDictionary setObject:direction forKey:@"direction"];
        [routes addObject:tempDictionary];
    }
    return routes;
}


- (BOOL)isRouteSaved:(DetailedRoute *)route WithDirection:(RouteDirection *)direction
{
    for (NSDictionary *savedRouteData in self.savedRoutes) {
        DetailedRoute *savedRoute = [savedRouteData objectForKey:@"route"];
        RouteDirection *savedDirection = [savedRouteData objectForKey:@"direction"];
        
        if ([savedRoute.tag isEqualToString:route.tag] && [savedDirection.tag isEqualToString:direction.tag]) {
            return YES;
        }
    }
    return NO;
}


- (void)toggleSavedStatusOfRoute:(DetailedRoute *)route WithDirection:(RouteDirection *)direction
{
    NSDictionary *routeDataDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:route, direction, nil]
                                                              forKeys:[NSArray arrayWithObjects:@"route", @"direction", nil]];
    
    if ([self isRouteSaved:route WithDirection:direction]) {
        [self.savedRoutes removeObject:routeDataDict];
    } else {
        [self.savedRoutes addObject:routeDataDict];
    }
    
    [self saveRoutes:self.savedRoutes withKey:@"Favorites"];
}

@end
