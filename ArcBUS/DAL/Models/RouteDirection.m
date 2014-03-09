//
//  RouteDirection.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "RouteDirection.h"

@implementation RouteDirection

- (id)init
{
    self = [super init];
    self.useForUI = YES;
    self.stops = [[NSArray alloc] init];
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.tag = [aDecoder decodeObjectForKey:@"tag"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.useForUI = [aDecoder decodeBoolForKey:@"useForUI"];
    self.stops = [aDecoder decodeObjectForKey:@"stops"];
    
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tag forKey:@"tag"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeBool:self.useForUI forKey:@"useForUI"];
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
