//
//  NextbusDataService.m
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "NextbusDataService.h"


static NSString *baseURL = @"http://webservices.nextbus.com/service/publicJSONFeed?a=%@&command=%@";

@implementation NextbusDataService

- (id)init
{
    self = [super init];
    
    self.webRepository = [[WebRepository alloc] init];
    self.responseParser = [[ResponseParser alloc] init];
    self.routeParser = [[RouteParser alloc] init];
    self.agency = @"mbta";
    
    return self;
}


- (id)initWithAgency:(NSString *)agency
{
    self = [self init];
    self.agency = agency;
    return self;
}


- (NSArray *)getRouteList
{
    NSString *url = [NSString stringWithFormat:baseURL, self.agency, @"routeList"];
    NSString *result = [self.webRepository getWithUrl:url];
    
    Response *response = [self.responseParser parseResponseFromJSON:result];
    if (response == nil) return nil;
    
    return [self.routeParser parseRouteListFromResponse:response];
}


- (DetailedRoute *)getRouteDetailsForTag:(NSString *)routeTag
{
    NSMutableString *url = [NSMutableString stringWithFormat:baseURL, self.agency, @"routeConfig"];
    [url appendString:[NSString stringWithFormat:@"&r=%@&terse", routeTag]];
    
    NSString *result = [self.webRepository getWithUrl:url];
    Response *response = [self.responseParser parseResponseFromJSON:result];
    if (response == nil) return nil;
    
    return [self.routeParser parseRouteConfigFromResponse:response];
}


- (DetailedRoute *)getRouteDetails:(SimpleRoute *)simpleRoute
{
    return [self getRouteDetailsForTag:simpleRoute.tag];
}


- (NSArray *)getPredictionsForRoute:(DetailedRoute *)route AndDirection:(RouteDirection *)direction
{
    NSMutableString *url = [NSMutableString stringWithFormat:baseURL, self.agency, @"predictionsForMultiStops"];
    for (RouteStop *stop in direction.stops) {
        [url appendString:[NSString stringWithFormat:@"&stops=%@|%@", route.tag, stop.tag]];
    }
    
    NSString *result = [self.webRepository getWithUrl:url];
    Response *response = [self.responseParser parseResponseFromJSON:result];
    
    if (response == nil)
        return nil;
    
    return [self.routeParser parsePredictionsFromResponse:response];
}

@end
