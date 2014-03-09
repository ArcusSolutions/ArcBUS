//
//  TwitterDataService.h
//  ArcBUS
//
//  Created by David C. Thor on 2/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter.h>
#import "TwitterDataServiceDelegate.h"

@interface TwitterDataService : NSObject

@property (nonatomic, strong) id<TwitterDataServiceDelegate> delegate;
@property (nonatomic, strong) STTwitterAPI *twitterAPI;

- (id)initWithDelegate:(id<TwitterDataServiceDelegate>)delegate;
- (void)getSearchResultsForQuery:(NSString *)query;
- (void)getTimelineWithScreenname:(NSString *)screenname;
- (void)getBannerForScreenname:(NSString *)screenname;

@end
