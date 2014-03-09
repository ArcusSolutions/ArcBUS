//
//  SavedRoutesViewController.h
//  AMBTA
//
//  Created by David C. Thor on 2/14/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RouteMapViewController.h"
#import "SplitViewDetailManager.h"
#import "SessionManager.h"

@interface SavedRoutesViewController : UITableViewController <SubstitutableDetailViewController>

@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

@end
