//
//  RouteStop.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteStop : NSObject <NSCoding>

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lon;
@property (nonatomic, strong) NSString *stopId;

@end
