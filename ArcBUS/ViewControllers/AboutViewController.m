//
//  AboutViewController.m
//  ArcBUS
//
//  Created by David C. Thor on 2/26/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//



#import "AboutViewController.h"

@interface AboutViewController ()

@end


static CGFloat previousScrollViewYOffset = 0;

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"About Us";
    self.title = @"Arcus Solutions";
    self.webView.scrollView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    NSURL *url = [NSURL URLWithString:@"http://arcussolutions.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.webView loadRequest:request];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.webView.delegate = self;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateWebViewFrame];
}


- (void)updateWebViewFrame
{
    int width = (int)self.view.frame.size.width;
    NSString* js = @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false);";
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, width]];
    
    CGRect frame = self.webView.frame;
    frame.size.width = width;
    [self.webView setFrame:frame];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
        CGRect navbarFrame = self.navigationController.navigationBar.frame;
        CGRect webViewFrame = self.webView.frame;
        
        navbarFrame.origin.y        = 20;
        webViewFrame.origin.y       = 0;
        webViewFrame.size.height    = self.view.frame.size.height;
        
        [self.navigationController.navigationBar setFrame:navbarFrame];
        [self.webView setFrame:webViewFrame];
        [self fadeNavbarItemsToAlpha:1.0];
    }
    
    [self updateWebViewFrame];
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        CGRect navbarFrame = self.navigationController.navigationBar.frame;
        CGFloat navbarHeight = navbarFrame.size.height;
        CGFloat navbarPercentageHidden = ((20 - navbarFrame.origin.y) / (navbarFrame.size.height - 1));
    
        CGFloat scrollViewOffset = scrollView.contentOffset.y;
        CGFloat scrollViewDiff = scrollViewOffset - previousScrollViewYOffset;
        CGFloat scrollViewHeight = scrollView.frame.size.height;
        CGFloat scrollViewContentHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
        CGFloat scrollViewInset = scrollView.contentInset.top;
    
        CGRect webViewFrame = self.webView.frame;
        if (scrollViewOffset <= -scrollViewInset) {
            navbarFrame.origin.y        = 20;
            webViewFrame.origin.y       = 0;
            webViewFrame.size.height    = self.view.frame.size.height;
        } else if ((scrollViewOffset + scrollViewHeight) >= scrollViewContentHeight) {
            navbarFrame.origin.y        = -(navbarHeight - 21);
            webViewFrame.origin.y       = -navbarHeight;
            webViewFrame.size.height    = self.view.frame.size.height + navbarHeight;
        } else {
            navbarFrame.origin.y        = MIN(20, MAX(-(navbarHeight - 21), navbarFrame.origin.y - scrollViewDiff));
            webViewFrame.origin.y       = MIN(0, MAX(-navbarHeight, webViewFrame.origin.y - scrollViewDiff));
            webViewFrame.size.height    = self.view.frame.size.height - MIN(0, MAX(-navbarHeight, webViewFrame.origin.y - scrollViewDiff));
        }
    
        [self.navigationController.navigationBar setFrame:navbarFrame];
        [self.webView setFrame:webViewFrame];
        [self fadeNavbarItemsToAlpha:(1 - navbarPercentageHidden)];
    
        previousScrollViewYOffset = scrollViewOffset;
    }
}


- (void)stoppedScrolling
{
    CGRect navbarFrame = self.navigationController.navigationBar.frame;
    if (navbarFrame.origin.y < 20) {
        [self animateNavbarTo:-(navbarFrame.size.height - 21)];
    }
}


- (void)fadeNavbarItemsToAlpha:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
    UIColor *newColor = self.navigationController.navigationBar.tintColor;
    if (newColor == nil) {
        newColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : newColor}];
}


- (void)animateNavbarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect navbarFrame = self.navigationController.navigationBar.frame;
        navbarFrame.origin.y = y;
        
        CGRect webViewFrame = self.webView.frame;
        webViewFrame.origin.y = -navbarFrame.size.height;
        webViewFrame.size.height = self.view.frame.size.height + navbarFrame.size.height;
        
        [self.navigationController.navigationBar setFrame:navbarFrame];
        [self.webView setFrame:webViewFrame];
        [self fadeNavbarItemsToAlpha:(navbarFrame.origin.y >= y ? 0 : 1)];
    }];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) [self stoppedScrolling];
}

@end
