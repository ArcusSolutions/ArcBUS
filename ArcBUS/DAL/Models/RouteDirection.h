//
//  RouteDirection.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "RouteStop.h"

@interface RouteDirection : NSObject <NSCoding>

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL useForUI;
@property (nonatomic, strong) NSArray *stops;

- (RouteStop *)nearestStopToLocation:(CLLocation *)location;

@end
