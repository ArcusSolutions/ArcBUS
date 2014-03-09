//
//  NearbyRoutesViewController.m
//  AMBTA
//
//  Created by David C. Thor on 2/14/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "NearbyRoutesViewController.h"

@interface NearbyRoutesViewController ()

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@end

@implementation NearbyRoutesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Nearby Routes";
    
    self.sessionManager = [[SessionManager alloc] init];
    self.routeDataManager = [[RouteDataManager alloc] initWithDelegate:self];
    self.sortedRouteList = [[NSArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if (self.routeDataManager.isRetrievingDetails) {
        self.loadingDialog = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.loadingDialog setLabelText:@"Please Wait"];
        [self.loadingDialog setDetailsLabelText:@"Loading Route Data"];
        [self.view addSubview:self.loadingDialog];
        [self.loadingDialog show:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.deckController setPanningMode:IIViewDeckFullViewPanning];
}


- (void)routeDataFinishedLoading
{
    if (self.userLocation != nil) {
        [self sortRoutes];
    }
}


- (void)sortRoutes
{
    [self.loadingDialog setDetailsLabelText:@"Calculating Nearest Routes"];
    self.sortedRouteList = [self sortRoutesByDistanceFromUserLocation:self.sessionManager.routeList];
    [self.loadingDialog hide:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedRouteList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyRoutesCell"];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    
    SimpleRoute *route = [self.sortedRouteList objectAtIndex:indexPath.row];
    [label setText:route.title];
    
    return cell;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.routeDataManager.isRetrievingDetails && self.userLocation == nil) {
        self.userLocation = [locations lastObject];
        [self sortRoutes];
    } else {
        self.userLocation = [locations lastObject];
    }
}


-(NSArray*) sortRoutesByDistanceFromUserLocation:(NSArray*)unsortedRoutes
{
    NSInteger numberOfElements = [unsortedRoutes count];
    if (numberOfElements <= 1) return unsortedRoutes;
    
    for (SimpleRoute *simpleRoute in unsortedRoutes) {
        DetailedRoute *routeDetails = [self.sessionManager.routeDetails objectForKey:simpleRoute.tag];
        RouteStop *nearestStop = [routeDetails nearestStopToLocation:self.userLocation];
        CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:nearestStop.lat longitude:nearestStop.lon];
        simpleRoute.distanceFromUser = [stopLocation distanceFromLocation:self.userLocation];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]  initWithKey:@"distanceFromUser" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return (NSMutableArray*)[unsortedRoutes sortedArrayUsingDescriptors:sortDescriptors];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NearbyToDirectionSegue"]) {
        DirectionViewController *viewController = (DirectionViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        SimpleRoute *route = [self.sortedRouteList objectAtIndex:indexPath.row];
        viewController.route = route;
    }
}


- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = nil;
    barButtonItem.image = [UIImage imageNamed:@"menu.png"];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}


- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
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

@end
