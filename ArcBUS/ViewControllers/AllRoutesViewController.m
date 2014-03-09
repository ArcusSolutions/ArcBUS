//
//  AllRoutesViewController.m
//  AMBTA
//
//  Created by David C. Thor on 2/11/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "AllRoutesViewController.h"

@interface AllRoutesViewController ()

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@end


@implementation AllRoutesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sessionManager = [[SessionManager alloc] init];
    self.routeDataManager = [[RouteDataManager alloc] init];
    self.nextbusDataService = [[NextbusDataService alloc] init];
    
    if ([self.sessionManager.routeList count] <= 0) {
        self.filteredRoutes = [[NSArray alloc] init];
        
        self.loadingDialog = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        self.loadingDialog.labelText = @"Loading";
        [self.view addSubview:self.loadingDialog];
        self.loadingDialog.delegate = self;
        [self.loadingDialog showWhileExecuting:@selector(initRouteData) onTarget:self withObject:nil animated:YES];
    } else {
        self.filteredRoutes = [NSArray arrayWithArray:self.sessionManager.routeList];
    }
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"All Routes"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
    
    
- (void)viewWillDisappear:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.deckController setPanningMode:IIViewDeckFullViewPanning];
}


- (void)initRouteData
{
    SessionManager *sessionManager = [[SessionManager alloc] init];
    
    [sessionManager setSimpleRouteList:[self.nextbusDataService getRouteList]];
    self.filteredRoutes = [NSArray arrayWithArray:sessionManager.routeList];
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
    return [self.filteredRoutes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllRoutesCell"];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    
    SimpleRoute *route = [self.filteredRoutes objectAtIndex:indexPath.row];
    [label setText:route.title];
    
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 0) {
        self.filteredRoutes = [self.sessionManager.routeList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title contains[c] %@", searchText]];
    } else {
        self.filteredRoutes = [NSArray arrayWithArray:self.sessionManager.routeList];
    }
    
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DirectionRouteSegue"]) {
        DirectionViewController *viewController = (DirectionViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        SimpleRoute *route = [self.filteredRoutes objectAtIndex:indexPath.row];
        viewController.route = route;
        
        [self.searchBar resignFirstResponder];
    }
}


- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.loadingDialog removeFromSuperview];
    self.loadingDialog = nil;
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
