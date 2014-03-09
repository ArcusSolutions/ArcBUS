//
//  PredictionDetailsViewController.h
//  ArcBUS
//
//  Created by David C. Thor on 2/23/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "GAITrackedViewController.h"
#import "NextbusDataService.h"
#import "DetailedRoute.h"
#import "RouteDirection.h"
#import "RouteStop.h"
#import "Prediction.h"
#import "PredictionsWrapper.h"
#import "PredictionsDirection.h"

@interface PredictionDetailsViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UILabel *routeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDirectionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) DetailedRoute *routeDetails;
@property (nonatomic, strong) RouteDirection *routeDirection;
@property (nonatomic, strong) RouteStop *routeStop;
@property (nonatomic, strong) NSArray *predictions;
@property (nonatomic, strong) MBProgressHUD *loadingDialog;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSString *lastRefreshTime;

@end
