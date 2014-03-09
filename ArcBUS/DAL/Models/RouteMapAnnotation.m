//
//  RouteMapAnnotation.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/21/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "RouteMapAnnotation.h"

@implementation RouteMapAnnotation

@synthesize title, subtitle, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d
{
    self = [super init];
    title = ttl;
    coordinate = c2d;
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c2d
{
    self = [super init];
    coordinate = c2d;
    return self;
}

- (void)setTitle:(NSString *)ttl
{
    title = ttl;
}

- (void)setSubtitle:(NSString *)subttl
{
    subtitle = subttl;
}

@end
