//
//  NearbyRoutesViewController.h
//  AMBTA
//
//  Created by David C. Thor on 2/14/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import "DirectionViewController.h"
#import "SplitViewDetailManager.h"
#import "SessionManager.h"
#import "RouteDataManager.h"
#import "RouteDataManagerDelegate.h"
#import "SimpleRoute.h"
#import "DetailedRoute.h"
#import "RouteDirection.h"
#import "RouteStop.h"

@interface NearbyRoutesViewController : UITableViewController <RouteDataManagerDelegate, CLLocationManagerDelegate, SubstitutableDetailViewController>

@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) RouteDataManager *routeDataManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MBProgressHUD *loadingDialog;
@property (nonatomic, strong) NSArray *sortedRouteList;
@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

@end
