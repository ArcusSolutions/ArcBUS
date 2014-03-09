//
//  MenuViewController.m
//  AMBTA
//
//  Created by David C. Thor on 2/10/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

static NSMutableDictionary *viewControllers;

@implementation MenuViewController

- (id)init {
    self = [super init];
    if (viewControllers == nil) viewControllers = [[NSMutableDictionary alloc] init];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (viewControllers == nil) viewControllers = [[NSMutableDictionary alloc] init];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title
    self.title = @"ArcBUS";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect navFrame = self.navigationItem.titleView.frame;
        navFrame.origin.x = 10;
        self.navigationItem.titleView.frame = navFrame;
    }
    
    // Initialization
    self.sessionManager = [[SessionManager alloc] initWithDelegate:self];
    [self initNavigation];
}


- (void)initNavigation
{
    NavigationItem *allRoutes = [[NavigationItem alloc] init];
    allRoutes.label = @"All Routes";
    allRoutes.imageName = @"ios7_icons_world.png";
    
    NavigationItem *nearby = [[NavigationItem alloc] init];
    nearby.label = @"Nearby";
    nearby.imageName = @"ios7_icons_location.png";
    
    NavigationItem *saved = [[NavigationItem alloc] init];
    saved.label = @"Favorites";
    saved.imageName = @"ios7_icons_star.png";
    
    NavigationItem *mbtaAlerts = [[NavigationItem alloc] init];
    mbtaAlerts.label = @"MBTA Alerts";
    mbtaAlerts.imageName = @"exclamation_icon.png";
    
    NavigationItem *settings = [[NavigationItem alloc] init];
    settings.label = @"About the Developers";
    settings.imageName = @"ios7_icons_users.png";
    
    self.navigationElements = [[NSArray alloc] initWithObjects:allRoutes, nearby, saved, mbtaAlerts, settings, nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.navigationElements count];
    } else {
        return [self.sessionManager.recentRoutes count];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else {
        return @"Recent Routes";
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    } else {
        return 32.0f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuRoutesCell"];
        UILabel *directionLabel = (UILabel*)[cell.contentView viewWithTag:1];
        UILabel *busNumber = (UILabel*)[cell.contentView viewWithTag:2];
        
        NSDictionary *routeDetails = [self.sessionManager.recentRoutes objectAtIndex:indexPath.row];
        DetailedRoute *route = [routeDetails objectForKey:@"route"];
        RouteDirection *direction = [routeDetails objectForKey:@"direction"];
        
        [directionLabel setText:direction.title];
        [busNumber setText:route.title];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuNavigationCell"];
        UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:2];
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:1];
        
        NavigationItem *navItem = [self.navigationElements objectAtIndex:indexPath.row];
        
        [label setText:navItem.label];
        [icon setImage:[UIImage imageNamed:navItem.imageName]];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NavigationItem *navItem = [self.navigationElements objectAtIndex:indexPath.row];
        [self switchToViewWithName:navItem.label];
    } else {
        RouteMapViewController *viewController = (RouteMapViewController *)[viewControllers objectForKey:@"Route Map"];
        if (viewController == nil)
        {
            viewController = (RouteMapViewController *)[self createViewControllerWithName:@"Route Map"];
            [viewControllers setObject:viewController forKey:@"Route Map"];
        }
        
        NSDictionary *recentRouteData = [self.sessionManager.recentRoutes objectAtIndex:indexPath.row];
        DetailedRoute *route = [recentRouteData objectForKey:@"route"];
        RouteDirection *direction = [recentRouteData objectForKey:@"direction"];
        [viewController setMapRoute:route AndDirection:direction];
        
        [self switchToViewWithName:@"Route Map"];
    }
}


- (UIViewController *)createViewControllerWithName:(NSString*)name
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:name];
        
        return controller;
    } else {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        UIViewController* controller = [mainStoryboard instantiateViewControllerWithIdentifier:name];
        
        return controller;
    }
}


- (void)switchToViewWithName:(NSString*)name
{
    UIViewController *controller = [viewControllers objectForKey:name];
    if (controller == nil)
    {
        controller = [self createViewControllerWithName:name];
        [viewControllers setObject:controller forKey:name];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        appDelegate.splitViewDetailManager.detailViewController = (UIViewController<SubstitutableDetailViewController> *)controller;
    } else {
        ((UINavigationController *) appDelegate.deckController.centerController).viewControllers = [NSArray arrayWithObjects:controller, nil];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:appDelegate.deckController action:@selector(toggleLeftView)];
        ((UINavigationController *) appDelegate.deckController.centerController).topViewController.navigationItem.leftBarButtonItem = button;
        [appDelegate.deckController setPanningMode:IIViewDeckFullViewPanning];
        [appDelegate.deckController toggleLeftView];
    }
}


- (void)recentRoutesUpdated:(NSArray *)recentRoutes
{
    [self.tableView reloadData];
}


- (void)routeDetailsReceived:(DetailedRoute *)routeDetails {}
- (void)routeListUpdated:(NSArray *)routeList {}

@end
