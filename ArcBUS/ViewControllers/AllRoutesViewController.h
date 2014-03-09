//
//  AllRoutesViewController.h
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <IIViewDeckController.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "AppDelegate.h"
#import "SessionManager.h"
#import "RouteDataManager.h"
#import "NextbusDataService.h"
#import "SimpleRoute.h"
#import "SplitViewDetailManager.h"
#import "DirectionViewController.h"

@interface AllRoutesViewController : UITableViewController <UISearchBarDelegate, MBProgressHUDDelegate, SubstitutableDetailViewController>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) RouteDataManager *routeDataManager;
@property (nonatomic, strong) NextbusDataService *nextbusDataService;
@property (nonatomic, strong) MBProgressHUD *loadingDialog;
@property (nonatomic, strong) NSArray *filteredRoutes;

@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

@end
