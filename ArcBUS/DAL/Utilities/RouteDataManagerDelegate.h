//
//  RouteDataManagerDelegate.h
//  AMBTA
//
//  Created by David C. Thor on 2/14/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/DetailedRoute.h"

@protocol RouteDataManagerDelegate <NSObject>

- (void)routeDataFinishedLoading;

@end