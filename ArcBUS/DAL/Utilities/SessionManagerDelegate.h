//
//  SessionManagerDelegate.h
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/DetailedRoute.h"

@protocol SessionManagerDelegate <NSObject>

- (void)routeListUpdated:(NSArray *)routeList;
- (void)routeDetailsReceived:(DetailedRoute *)routeDetails;
- (void)recentRoutesUpdated:(NSArray *)recentRoutes;

@end
