//
//  SavedRoutesViewController.m
//  AMBTA
//
//  Created by David C. Thor on 2/14/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "SavedRoutesViewController.h"

@interface SavedRoutesViewController ()

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@end



@implementation SavedRoutesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Saved Routes";
    
    self.sessionManager = [[SessionManager alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.deckController setPanningMode:IIViewDeckFullViewPanning];
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sessionManager.savedRoutes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *bookmarkData = [self.sessionManager.savedRoutes objectAtIndex:indexPath.row];
    DetailedRoute *route = [bookmarkData objectForKey:@"route"];
    RouteDirection *direction = [bookmarkData objectForKey:@"direction"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedCell"];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *subLabel = (UILabel *)[cell.contentView viewWithTag:2];
    
    [label setText:[NSString stringWithFormat:@"%@: %@", route.title, direction.title]];
    [subLabel setText:[NSString stringWithFormat:@"%@", direction.name]];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SavedToMapSeque"]) {
        RouteMapViewController *viewController = (RouteMapViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *savedRouteData = [self.sessionManager.savedRoutes objectAtIndex:indexPath.row];
        DetailedRoute *route = [savedRouteData objectForKey:@"route"];
        RouteDirection *direction = [savedRouteData objectForKey:@"direction"];
        
        [viewController setMapRoute:route AndDirection:direction];
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
