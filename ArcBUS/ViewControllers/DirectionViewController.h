//
//  DirectionViewController.h
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "RouteMapViewController.h"
#import "SessionManager.h"
#import "SessionManagerDelegate.h"
#import "RouteDataManager.h"
#import "SimpleRoute.h"

@interface DirectionViewController : UITableViewController <SessionManagerDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) RouteDataManager *routeDataManager;
@property (nonatomic, strong) MBProgressHUD *loadingDialog;
@property (nonatomic, strong) SimpleRoute *route;
@property (nonatomic, strong) DetailedRoute *routeDetails;

@end
