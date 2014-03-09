//
//  RouteStop.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "RouteStop.h"

@implementation RouteStop

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.tag = [aDecoder decodeObjectForKey:@"tag"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.lat = [aDecoder decodeFloatForKey:@"lat"];
    self.lon = [aDecoder decodeFloatForKey:@"lon"];
    self.stopId = [aDecoder decodeObjectForKey:@"stopId"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tag forKey:@"tag"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeFloat:self.lat forKey:@"lat"];
    [aCoder encodeFloat:self.lon forKey:@"lon"];
    [aCoder encodeObject:self.stopId forKey:@"stopId"];
}

@end
