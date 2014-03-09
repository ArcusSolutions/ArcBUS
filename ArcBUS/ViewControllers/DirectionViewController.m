//
//  DirectionViewController.m
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "DirectionViewController.h"

@interface DirectionViewController ()

@end

@implementation DirectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.deckController setPanningMode:IIViewDeckNoPanning];
    
    self.sessionManager = [[SessionManager alloc] initWithDelegate:self];
    self.routeDataManager = [[RouteDataManager alloc] init];
    
    if ([self.sessionManager.routeDetails objectForKey:self.route.tag] == nil) {
        [self.routeDataManager setRouteAsPriority:self.route];
        
        self.loadingDialog = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.view addSubview:self.loadingDialog];
        self.loadingDialog.delegate = self;
        [self.loadingDialog show:YES];
    } else {
        self.routeDetails = [self.sessionManager.routeDetails objectForKey:self.route.tag];
        self.title = self.routeDetails.title;
    }
}

- (void)routeDetailsReceived:(DetailedRoute *)routeDetails
{
    DetailedRoute *detailedRoute = [self.sessionManager.routeDetails objectForKey:self.route.tag];
    
    if (self.routeDetails == nil && detailedRoute != nil) {
        self.routeDetails = [self.sessionManager.routeDetails objectForKey:self.route.tag];
        self.title = self.routeDetails.title;
        
        [self.loadingDialog hide:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.routeDetails.directions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectionCell"];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *directionLabel = (UILabel *)[cell.contentView viewWithTag:2];
    
    RouteDirection *direction = [self.routeDetails.directions objectAtIndex:indexPath.row];
    [label setText:direction.title];
    [directionLabel setText:direction.name];
    
    return cell;
}


- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.loadingDialog removeFromSuperview];
    self.loadingDialog = nil;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DirectionToMapSegue"]) {
        RouteMapViewController *viewController = (RouteMapViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RouteDirection *direction = [self.routeDetails.directions objectAtIndex:indexPath.row];
        [viewController setMapRoute:self.routeDetails AndDirection:direction];
    }
}


- (void)routeListUpdated:(NSArray *)routeList {}
- (void)recentRoutesUpdated:(NSArray *)recentRoutes {}

@end
