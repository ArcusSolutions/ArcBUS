//
//  RouteMapViewController.h
//  AMBTA
//
//  Created by David C. Thor on 2/13/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MBProgressHUD.h>
#import "GAITrackedViewController.h"
#import "PredictionDetailsViewController.h"
#import "SplitViewDetailManager.h"
#import "NextbusDataService.h"
#import "SessionManager.h"
#import "DetailedRoute.h"
#import "RouteDirection.h"
#import "RouteMapAnnotation.h"
#import "PredictionsWrapper.h"
#import "PredictionsDirection.h"
#import "Prediction.h"

@interface RouteMapViewController : GAITrackedViewController <MKMapViewDelegate, SubstitutableDetailViewController>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) DetailedRoute *routeDetails;
@property (nonatomic, strong) RouteDirection *routeDirection;
@property (nonatomic, strong) NSArray *stopAnnotations;
@property (nonatomic, strong) MKPolyline *routePolyline;
@property (nonatomic, assign) BOOL mapViewIsLoaded;
@property (nonatomic, strong) NSArray *predictions;
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;
@property (nonatomic, assign) BOOL waitForMapViewChange;

- (void)setMapRoute:(DetailedRoute *)route AndDirection:(RouteDirection *)direction;

@end
