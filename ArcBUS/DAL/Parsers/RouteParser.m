//
//  RouteParser.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "RouteParser.h"

@implementation RouteParser

- (NSArray *)parseRouteListFromResponse:(Response *)response
{
    NSMutableArray *routes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *routeDict in [response.body objectForKey:@"route"]) {
        SimpleRoute *route = [[SimpleRoute alloc] initWithData:routeDict];
        [routes addObject:route];
    }
    
    return [NSArray arrayWithArray:routes];
}


- (DetailedRoute *)parseRouteConfigFromResponse:(Response *)response
{
    NSDictionary *routeDict = [response.body objectForKey:@"route"];
    
    DetailedRoute *route = [[DetailedRoute alloc] init];
    route.tag           = [routeDict objectForKey:@"tag"];
    route.title         = [routeDict objectForKey:@"title"];
    route.color         = [self getUIColorObjectFromHexString:[routeDict objectForKey:@"color"]];
    route.oppositeColor = [self getUIColorObjectFromHexString:[routeDict objectForKey:@"oppositeColor"]];
    route.latMin        = (CGFloat)[[routeDict objectForKey:@"latMin"] floatValue];
    route.lonMin        = (CGFloat)[[routeDict objectForKey:@"lonMin"] floatValue];
    route.latMax        = (CGFloat)[[routeDict objectForKey:@"latMax"] floatValue];
    route.lonMax        = (CGFloat)[[routeDict objectForKey:@"lonMax"] floatValue];
    
    NSMutableArray *allStops = [[NSMutableArray alloc] init];
    NSMutableArray *directions = [[NSMutableArray alloc] init];
    NSObject *directionsObj = [routeDict objectForKey:@"direction"];
    
    if ([directionsObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *directionDict = (NSDictionary *)directionsObj;
        
        RouteDirection *direction = [self parseRouteDirectionFromDictonary:directionDict WithStops:[routeDict objectForKey:@"stop"]];
        [directions addObject:direction];
        [allStops addObjectsFromArray:direction.stops];
    } else {
        for (NSDictionary *directionDict in [routeDict objectForKey:@"direction"]) {
            RouteDirection *direction = [self parseRouteDirectionFromDictonary:directionDict WithStops:[routeDict objectForKey:@"stop"]];
            [directions addObject:direction];
            [allStops addObjectsFromArray:direction.stops];
        }
    }
    
    route.stops         = allStops;
    route.directions    = directions;
    return route;
}


- (RouteDirection *)parseRouteDirectionFromDictonary:(NSDictionary *)directionDict WithStops:(NSArray *)routeStops
{
    RouteDirection *direction   = [[RouteDirection alloc] init];
    direction.tag               = [directionDict objectForKey:@"tag"];
    direction.title             = [directionDict objectForKey:@"title"];
    direction.name              = [directionDict objectForKey:@"name"];
    direction.useForUI          = [[directionDict objectForKey:@"useForUI"] boolValue];
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    for (NSDictionary *stopDict in [directionDict objectForKey:@"stop"]) {
        RouteStop *stop = [self getStopWithTag:[stopDict objectForKey:@"tag"] fromStops:routeStops];
        [stops addObject:stop];
    }
    
    direction.stops = stops;
    return direction;
}


- (NSArray *)parsePredictionsFromResponse:(Response *)response
{
    NSMutableArray *predictions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *predictionDict in [response.body objectForKey:@"predictions"]) {
        if (![predictionDict isKindOfClass:[NSString class]])
            [predictions addObject:[[PredictionsWrapper alloc] initWithData:predictionDict]];
    }
    
    return [NSArray arrayWithArray:predictions];
}


- (RouteStop *)getStopWithTag:(NSString *)tag fromStops:(NSArray *)stops
{
    for (NSDictionary *stopDict in stops) {
        RouteStop *stop = [[RouteStop alloc] init];
        stop.tag        = [stopDict objectForKey:@"tag"];
        stop.title      = [stopDict objectForKey:@"title"];
        stop.lat        = (CGFloat)[[stopDict objectForKey:@"lat"] floatValue];
        stop.lon        = (CGFloat)[[stopDict objectForKey:@"lon"] floatValue];
        stop.stopId     = [stopDict objectForKey:@"stopId"];
        
        if ([stop.tag isEqualToString:tag]) {
            return stop;
        }
    }
    
    return nil;
}


- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0];
    
    return color;
}


- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

@end
