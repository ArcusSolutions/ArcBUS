//
//  DetailedRoute.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "DetailedRoute.h"

@implementation DetailedRoute

- (id)init
{
    self = [super init];
    self.stops = [[NSArray alloc] init];
    self.directions = [[NSArray alloc] init];
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.tag = [aDecoder decodeObjectForKey:@"tag"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.color = [aDecoder decodeObjectForKey:@"color"];
    self.oppositeColor = [aDecoder decodeObjectForKey:@"oppositeColor"];
    self.latMin = [aDecoder decodeFloatForKey:@"latMin"];
    self.lonMin = [aDecoder decodeFloatForKey:@"lonMin"];
    self.latMax = [aDecoder decodeFloatForKey:@"latMax"];
    self.lonMax = [aDecoder decodeFloatForKey:@"lonMax"];
    self.directions = [aDecoder decodeObjectForKey:@"directions"];
    self.stops = [aDecoder decodeObjectForKey:@"stops"];
    
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tag forKey:@"tag"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.color forKey:@"color"];
    [encoder encodeObject:self.oppositeColor forKey:@"oppositeColor"];
    [encoder encodeFloat:self.latMin forKey:@"latMin"];
    [encoder encodeFloat:self.lonMin forKey:@"lonMin"];
    [encoder encodeFloat:self.latMax forKey:@"latMax"];
    [encoder encodeFloat:self.lonMax forKey:@"lonMax"];
    [encoder encodeObject:self.directions forKey:@"directions"];
    [encoder encodeObject:self.stops forKey:@"stops"];
}


- (RouteStop *)nearestStopToLocation:(CLLocation *)location
{
    RouteStop *nearestStop;
    CGFloat nearestDistance = INFINITY;
    
    for (RouteStop *stop in self.stops) {
        CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:stop.lat longitude:stop.lon];
        CGFloat distance = [stopLocation distanceFromLocation:location];
        
        if (distance < nearestDistance) {
            nearestDistance = distance;
            nearestStop = stop;
        }
    }
    
    return nearestStop;
}

@end
