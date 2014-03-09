//
//  NextbusDataService.h
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Repositories/WebRepository.h"
#import "../Parsers/ResponseParser.h"
#import "../Parsers/RouteParser.h"
#import "../Models/Response.h"
#import "../Models/SimpleRoute.h"
#import "../Models/DetailedRoute.h"

@interface NextbusDataService : NSObject

@property (nonatomic, strong) WebRepository *webRepository;
@property (nonatomic, strong) ResponseParser *responseParser;
@property (nonatomic, strong) RouteParser *routeParser;
@property (nonatomic, strong) NSString *agency;

- (id)initWithAgency:(NSString *)agency;
- (NSArray *)getRouteList;
- (DetailedRoute *)getRouteDetailsForTag:(NSString *)routeTag;
- (DetailedRoute *)getRouteDetails:(SimpleRoute *)simpleRoute;
- (NSArray *)getPredictionsForRoute:(DetailedRoute *)route AndDirection:(RouteDirection *)direction;

@end
