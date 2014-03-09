//
//  AboutViewController.h
//  ArcBUS
//
//  Created by David C. Thor on 2/26/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "SplitViewDetailManager.h"

@interface AboutViewController : GAITrackedViewController <UIWebViewDelegate, UIScrollViewDelegate, SubstitutableDetailViewController>

@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
