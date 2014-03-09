//
//  RouteMapViewController.m
//  AMBTA
//
//  Created by David C. Thor on 2/13/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "RouteMapViewController.h"

@interface RouteMapViewController ()

@property (nonatomic, strong) UIPopoverController *masterPopoverController;

@end

@implementation RouteMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Map";
    
    self.sessionManager = [[SessionManager alloc] init];
    self.mapViewIsLoaded = NO;
    
    UIImage *buttonImage = [UIImage imageNamed:@"ios7_icons_star_white.png"];
    if ([self.sessionManager isRouteSaved:self.routeDetails WithDirection:self.routeDirection]) {
        buttonImage = [UIImage imageNamed:@"ios7_icons_star_white_solid.png"];
    }
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleSaved)];
    self.navigationItem.rightBarButtonItem = button;
    
    MKCoordinateRegion region;
    region.center.latitude = 42.3581;
    region.center.longitude = -71.0636;
    region.span.latitudeDelta = 0.0725;
    region.span.longitudeDelta = 0.0725;

    self.waitForMapViewChange = TRUE;
    [self.mapView setRegion:region animated:YES];
    [self drawRoutePath];
    
    [self performSelectorInBackground:@selector(initPredictionData) withObject:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    if (self.mapViewIsLoaded) {
        [self initPredictionData];
    }
}


- (void)toggleSaved
{
    [self.sessionManager toggleSavedStatusOfRoute:self.routeDetails WithDirection:self.routeDirection];
    UIImage *buttonImage = [UIImage imageNamed:@"ios7_icons_star_white.png"];
    if ([self.sessionManager isRouteSaved:self.routeDetails WithDirection:self.routeDirection]) {
        buttonImage = [UIImage imageNamed:@"ios7_icons_star_white_solid.png"];
    }
    
    self.navigationItem.rightBarButtonItem.image = buttonImage;
}


- (void)setMapRoute:(DetailedRoute *)route AndDirection:(RouteDirection *)direction
{
    [self.mapView removeOverlay:self.routePolyline];
    [self.mapView removeAnnotations:self.stopAnnotations];
    
    self.stopAnnotations = [[NSArray alloc] init];
    self.sessionManager = [[SessionManager alloc] init];
    self.mapView.delegate = self;
    
    self.routeDetails = route;
    self.routeDirection = direction;
    self.title = self.routeDetails.title;
    
    [self.sessionManager addRouteToHistory:route WithDirection:direction];
    [self drawRoutePath];
    
    if (self.mapViewIsLoaded) {
        [self showNearestRouteDetails];
        [self initPredictionData];
    }
}


- (void)showNearestRouteDetails
{
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude
                                                          longitude:self.mapView.userLocation.coordinate.longitude];
    RouteStop *nearestStop = [self.routeDirection nearestStopToLocation:userLocation];
    
    MKCoordinateRegion region;
    region.center.latitude = nearestStop.lat;
    region.center.longitude = nearestStop.lon;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    self.waitForMapViewChange = YES;
    [self.mapView setRegion:region animated:YES];
    
    MBProgressHUD *toast = [MBProgressHUD showHUDAddedTo:self.mapView animated:YES];
    toast.mode = MBProgressHUDModeText;
    toast.labelText = @"Found nearest stop";
    toast.labelFont = [UIFont systemFontOfSize:13];
    toast.removeFromSuperViewOnHide = YES;
    toast.margin = 8.f;
    toast.yOffset = 175.f;
    [toast hide:YES afterDelay:1.0];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.waitForMapViewChange) {
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.coordinate.latitude
                                                              longitude:self.mapView.userLocation.coordinate.longitude];
        RouteStop *nearestStop = [self.routeDirection nearestStopToLocation:userLocation];
        for (RouteMapAnnotation *annotation in self.stopAnnotations) {
            if ([annotation.title isEqualToString:nearestStop.title]) {
                [self.mapView selectAnnotation:annotation animated:YES];
            }
        }
    }
    
    self.waitForMapViewChange = NO;
}

- (void)drawRoutePath
{
    NSMutableArray *stopAnnotations = [[NSMutableArray alloc] init];
    
    NSInteger numStops = [self.routeDirection.stops count];
    CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * numStops);
    
    NSInteger index = 0;
    for (RouteStop *stop in self.routeDirection.stops) {
        CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:stop.lat longitude:stop.lon];
        
        RouteMapAnnotation *annotation = [[RouteMapAnnotation alloc] initWithTitle:stop.title andCoordinate:stopLocation.coordinate];
        [stopAnnotations addObject:annotation];
        [self.mapView addAnnotation:annotation];
        
        coordinates[index] = stopLocation.coordinate;
        index++;
    }
    
    self.stopAnnotations = [NSArray arrayWithArray:stopAnnotations];
    self.routePolyline = [MKPolyline polylineWithCoordinates:coordinates count:numStops];
    [self.mapView addOverlay:self.routePolyline];
}


- (void)initPredictionData
{
    NextbusDataService *nextbusDataService = [[NextbusDataService alloc] init];
    self.predictions = [nextbusDataService getPredictionsForRoute:self.routeDetails AndDirection:self.routeDirection];
    
    for (NSInteger index = 0; index < [self.stopAnnotations count]; index++) {
        RouteMapAnnotation *annotation = [self.stopAnnotations objectAtIndex:index];
        
        if (index < [self.predictions count]) {
            PredictionsWrapper *predictionWrapper = [self.predictions objectAtIndex:index];
            PredictionsDirection *predDirection = [predictionWrapper getDirectionForTitle:self.routeDirection.title];
            
            if (predDirection != nil) {
                Prediction *prediction = [predDirection.predictions firstObject];
                [annotation setSubtitle:[NSString stringWithFormat:@"Departs in %ld minutes", (long)prediction.minutes]];
            } else {
                [annotation setSubtitle:@"Departure information unavailable"];
            }
        } else {
            [annotation setSubtitle:@"Departure information unavailable"];
        }
    }
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *line = overlay;
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:line];
        renderer.lineWidth = 4;
        renderer.strokeColor = [UIColor blackColor];
        
        return renderer;
    }
    
    return nil;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = nil;
    if (annotation != self.mapView.userLocation)
    {
        static NSString *viewIdentifier = @"routeMapPin";
        view = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:viewIdentifier];
        
        if (view == nil) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewIdentifier];
        }
        
        view.canShowCallout = YES;
        view.enabled = YES;
        view.frame = CGRectMake(10, 10, 16, 16);
        view.alpha = 1;
        view.layer.cornerRadius = 8;
        view.backgroundColor = [UIColor whiteColor];
        UIButton *stopInfoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        view.rightCalloutAccessoryView = stopInfoButton;
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 12, 12)];
        subView.layer.cornerRadius = 6;
        subView.backgroundColor = [UIColor blackColor];
        
        [view addSubview:subView];
    }
    
    return view;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    PredictionDetailsViewController *predictionsController = (PredictionDetailsViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"PredictionDetails"];
    predictionsController.routeDetails = self.routeDetails;
    predictionsController.routeDirection = self.routeDirection;
    predictionsController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    RouteMapAnnotation *routeAnnotation = view.annotation;
    for (RouteStop *stop in self.routeDirection.stops) {
        if ([routeAnnotation.title isEqualToString:stop.title]) {
            predictionsController.routeStop = stop;
        }
    }
    
    UINavigationController *modalNavigation = [[UINavigationController alloc] initWithRootViewController:predictionsController];
    [self presentViewController:modalNavigation animated:YES completion:nil];
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if (!self.mapViewIsLoaded) [self showNearestRouteDetails];
    self.mapViewIsLoaded = YES;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PredictionDetailsSegue"]) {
        PredictionDetailsViewController *viewController = (PredictionDetailsViewController *)[segue destinationViewController];
        viewController.routeDetails = self.routeDetails;
        viewController.routeDirection = self.routeDirection;
    }
}

@end
