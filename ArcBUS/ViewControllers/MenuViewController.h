//
//  MenuViewController.h
//  AMBTA
//
//  Created by David C. Thor on 2/10/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RouteMapViewController.h"
#import "SessionManager.h"
#import "SessionManagerDelegate.h"
#import "NavigationItem.h"

@interface MenuViewController : UITableViewController <SessionManagerDelegate>

@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) NSArray *navigationElements;

@end
