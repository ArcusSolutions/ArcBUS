//
//  AppDelegate.h
//  AMBTA
//
//  Created by David C. Thor on 2/10/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IIViewDeckController.h>
#import "GAI.h"
#import "ViewControllers/SplitViewDetailManager.h"
#import "ViewControllers/MenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) IIViewDeckController *deckController;
@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, retain) SplitViewDetailManager *splitViewDetailManager;
@property (strong, nonatomic) UIWindow *window;

@end
