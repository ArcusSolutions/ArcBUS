//
//  AlertsViewController.h
//  ArcBUS
//
//  Created by David C. Thor on 2/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD.h>
#import "GAITrackedViewController.h"
#import "SplitViewDetailManager.h"
#import "TwitterDataService.h"
#import "TwitterDataServiceDelegate.h"

@interface AlertsViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, TwitterDataServiceDelegate, SubstitutableDetailViewController>

@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;
@property (weak, nonatomic) IBOutlet UILabel *twitterName;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandle;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MBProgressHUD *loadingDialog;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) NSDictionary *banner;
@property (nonatomic, strong) NSMutableArray *tweetImages;

@end
