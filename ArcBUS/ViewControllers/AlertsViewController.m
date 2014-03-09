//
//  AlertsViewController.m
//  ArcBUS
//
//  Created by David C. Thor on 2/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "AlertsViewController.h"

@interface AlertsViewController ()

@end


static int queryCount = 0;

@implementation AlertsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Alerts";
    self.title = @"MBTA Alerts";
    self.tweets = [[NSArray alloc] init];
    
    self.loadingDialog = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:self.loadingDialog];
    [self.loadingDialog show:TRUE];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(initTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self initTweets];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)initTweets
{
    self.tweetImages = [[NSMutableArray alloc] init];
    
    TwitterDataService *twitterService = [[TwitterDataService alloc] initWithDelegate:self];
    [twitterService getTimelineWithScreenname:@"mbta_alerts"];
    queryCount += 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];
    NSDictionary *twitterStatus = [self.tweets objectAtIndex:indexPath.row];
    
    if ([self.tweetImages count] > indexPath.row) {
        UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:1];
        UIImage *userImage = [self.tweetImages objectAtIndex:indexPath.row];
        [icon setImage:userImage];
    }
    
    [label setText:[twitterStatus objectForKey:@"text"]];
        
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}


- (void)searchResultsReceived:(NSArray *)results
{
    self.tweets = results;
    
    for (NSDictionary *twitterStatus in self.tweets) {
        UIImage *tweetImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[twitterStatus objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
        [self.tweetImages addObject:tweetImage];
    }
    
    queryCount--;
    if (queryCount <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *twitterStatus = [self.tweets firstObject];
            
            NSString *profileImageUrl = [[[twitterStatus objectForKey:@"user"] objectForKey:@"profile_image_url"] stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"];
            UIImage *twitterImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageUrl]]];
            [self.twitterImage setImage:twitterImage];
            self.twitterImage.layer.cornerRadius = 5.0;
            self.twitterImage.layer.masksToBounds = YES;
            self.twitterImage.layer.borderWidth = 3.0;
            self.twitterImage.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.twitterName setText:[[twitterStatus objectForKey:@"user"] objectForKey:@"name"]];
            [self.twitterHandle setText:[NSString stringWithFormat:@"@%@", [[twitterStatus objectForKey:@"user"] objectForKey:@"screen_name"]]];
            
            [self.tableView reloadData];
            [self.loadingDialog hide:TRUE];
            [self.refreshControl endRefreshing];
        });
    }
}


- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        if (navigationPaneBarButtonItem)
            [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem];
        else
            [self.navigationItem setLeftBarButtonItem:nil];
        
        _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
    }
}


- (void)bannerReceived:(NSDictionary *)banner {}

@end
