//
//  AppDelegate.m
//  AMBTA
//
//  Created by David C. Thor on 2/10/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(33/255.0) green:(101/255.0) blue:(130/255.0) alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self initiPadLayout];
    } else {
        [self initiPhoneLayout];
    }
    
    [self.window makeKeyAndVisible];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 5;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    [[GAI sharedInstance] trackerWithTrackingId:NSLocalizedString(@"Google Analytics Key",nil)];
    
    return YES;
}


- (void)initiPhoneLayout
{
    UIStoryboard *iphoneStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController *menuController = [iphoneStoryboard instantiateViewControllerWithIdentifier:@"Menu"];
    
    UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
    self.deckController =  [[IIViewDeckController alloc] initWithCenterViewController:navigationController leftViewController:menuController rightViewController:nil];
    [self.deckController setElastic:YES];
    self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    self.deckController.parallaxAmount = 0.2;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.deckController action:@selector(toggleLeftView)];
    navigationController.topViewController.navigationItem.leftBarButtonItem = button;
    
    self.window.rootViewController = self.deckController;
}


- (void)initiPadLayout
{
    self.splitViewController = (UISplitViewController *)self.window.rootViewController;
    self.splitViewDetailManager = [[SplitViewDetailManager alloc] init];
    self.splitViewDetailManager.splitViewController = self.splitViewController;
    self.splitViewController.delegate = self.splitViewDetailManager;
    
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    self.splitViewDetailManager.detailViewController = (UIViewController<SubstitutableDetailViewController> *)navigationController.topViewController;
}

							
- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
