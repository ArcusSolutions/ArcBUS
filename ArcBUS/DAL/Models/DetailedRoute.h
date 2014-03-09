//
//  DetailedRoute.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouteDirection.h"
#import "RouteStop.h"

@interface DetailedRoute : NSObject <NSCoding>

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *oppositeColor;
@property (nonatomic) CGFloat latMin;
@property (nonatomic) CGFloat lonMin;
@property (nonatomic) CGFloat latMax;
@property (nonatomic) CGFloat lonMax;
@property (nonatomic, strong) NSArray *directions;
@property (nonatomic, strong) NSArray *stops;

- (RouteStop *)nearestStopToLocation:(CLLocation *)location;

@end
